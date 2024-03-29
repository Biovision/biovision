# frozen_string_literal: true

# User
#
# Attributes:
#   agent_id [Agent], optional
#   allow_mail [boolean]
#   banned [boolean]
#   birthday [date], optional
#   bot [boolean]
#   created_at [DateTime]
#   data [jsonb]
#   deleted [boolean]
#   email [string], optional
#   email_confirmed [boolean]
#   image [SimpleImageUploader], optional
#   inviter_id [User], optional
#   ip_address_id [IpAddress], optional
#   language_id [Language], optional
#   last_seen [datetime], optional
#   notice [string], optional
#   password_digest [string]
#   phone [string], optional
#   phone_confirmed [boolean]
#   primary_id [User], optional
#   profile [Jsonb]
#   referral_link [string]
#   screen_name [string]
#   slug [string]
#   super_user [boolean]
#   updated_at [DateTime]
#   uuid [uuid]
class User < ApplicationRecord
  include Checkable
  include HasLanguage
  include HasTrack
  include HasUuid
  include Toggleable

  EMAIL_LIMIT = 250
  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i.freeze
  FLAG_SKIP_SCREEN_NAME = 'skip_screen_name_validation'
  NOTICE_LIMIT = 255
  PHONE_LIMIT = 50
  SLUG_LIMIT = 36
  SLUG_PATTERN = /\A[_a-z0-9][-_a-z0-9]{0,34}[_a-z0-9]\z/i.freeze
  SLUG_PATTERN_HTML = '^[_a-zA-Z0-9][-_a-zA-Z0-9]{0,34}[_a-zA-Z0-9]$'

  attr_accessor :code

  toggleable :email_confirmed, :allow_mail, :phone_confirmed

  has_secure_password
  mount_uploader :image, SimpleImageUploader

  belongs_to :inviter, class_name: User.to_s, optional: true
  has_many :invitees, class_name: User.to_s, foreign_key: :inviter_id, dependent: :nullify
  has_many :tokens, dependent: :delete_all
  has_many :codes, dependent: :delete_all
  has_many :foreign_users, dependent: :delete_all if Gem.loaded_specs.key?('biovision-oauth')
  has_many :login_attempts, dependent: :delete_all
  has_many :user_languages, dependent: :delete_all
  has_many :user_roles, dependent: :destroy
  has_many :user_groups, dependent: :destroy

  after_initialize :prepare_referral_link

  before_validation { self.email = nil if email.blank? }
  before_validation { self.phone = nil if phone.blank? }
  after_validation :normalize_slug

  validate do |entity|
    Biovision::Components::UsersComponent[entity].validate
  end

  validates :screen_name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, uniqueness: { case_sensitive: false }, allow_nil: true
  validates :phone, uniqueness: { case_sensitive: false }, allow_nil: true
  validates_length_of :phone, maximum: PHONE_LIMIT
  validates_length_of :notice, maximum: NOTICE_LIMIT

  scope :bots, ->(f) { where(bot: f.to_i.positive?) unless f.blank? }
  scope :email_like, ->(v) { where('email ilike ?', "%#{v}%") unless v.blank? }
  scope :with_email, ->(v) { where('lower(email) = lower(?)', v.to_s) }
  scope :list_for_administration, -> { order('id desc') }
  scope :search, ->(q) { where('screen_name ilike ?', "%#{q}%") unless q.blank? }

  def self.[](login)
    find_by(slug: login) || find_by_contact(login)
  end

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.profile_parameters
    %i[image allow_mail birthday]
  end

  def self.sensitive_parameters
    %i[email phone password password_confirmation]
  end

  # @param [String] login
  def self.find_by_contact(login)
    if login.index('@').to_i.positive?
      User.with_email(login).first
    elsif login[0] == '+'
      User.find_by(phone: login)
    end
  end

  # Parameters for registration
  def self.new_profile_parameters
    profile_parameters + sensitive_parameters + %i[screen_name]
  end

  # Administrative parameters
  def self.entity_parameters
    flags = %i[banned bot email_confirmed phone_confirmed]

    new_profile_parameters + flags + %i[notice screen_name slug]
  end

  def self.ids_range
    min = User.minimum(:id).to_i
    max = User.maximum(:id).to_i
    (min..max)
  end

  # @param [String] role_name
  def role?(role_name)
    return true if super_user?

    role = Role[role_name]
    role_ids.include?(role&.id)
  end

  def role_ids
    Array(data[Role::CACHE_KEY]).map(&:to_i)
  end

  # @param [Role] role
  def add_role(role)
    role&.add_user(self)
  end

  # @param [Role] role
  def remove_role(role)
    role&.remove_user(self)
  end

  # Name to be shown as profile
  #
  # This can be redefined for cases when something other than screen name should
  # be used.
  #
  # @return [String]
  def profile_name
    email_as_login? ? email.to_s.split('@').first : screen_name
  end

  def text_for_link
    profile_name
  end

  def name_for_letter
    profile['name'].blank? ? profile_name : profile['name']
  end

  # @param [TrueClass|FalseClass] include_patronymic
  def full_name(include_patronymic = false)
    result = [name_for_letter]
    result << profile['patronymic'].to_s.strip if include_patronymic
    result << profile['surname'].to_s.strip
    result.compact.join(' ')
  end

  def can_receive_letters?
    allow_mail? && !email.blank?
  end

  def email_as_login?
    !data[Biovision::Components::UsersComponent::SETTING_EMAIL_AS_LOGIN].blank?
  end

  def phone_as_login?
    !data[Biovision::Components::UsersComponent::SETTING_PHONE_AS_LOGIN].blank?
  end

  # @param [String|Symbol] component_slug
  def component_data(component_slug)
    data.dig('components', component_slug.to_s).to_h
  end

  # @param [String|Symbol] component_slug
  # @param [Hash] component_data
  def new_component_data(component_slug, component_data)
    data['components'] ||= {}
    data['components'][component_slug.to_s] = component_data.to_h
  end

  def world_url
    key = screen_name.downcase == slug ? screen_name : slug
    "/u/#{CGI.escape(key)}"
  end

  def tiny_avatar_url
    return 'placeholders/user.svg' if image.blank?

    image.tiny_url
  end

  def age
    return if birthday.blank?

    now = Time.now.utc.to_date
    next_month = now.month > birthday.month
    next_day = (now.month == birthday.month && now.day >= birthday.day)
    delta = next_month || next_day ? 0 : 1
    now.year - birthday.year - delta
  end

  private

  def prepare_referral_link
    self.referral_link = SecureRandom.alphanumeric(12) if referral_link.blank?
  end

  def normalize_slug
    self.slug = screen_name.to_s if slug.blank?
    self.slug = slug.to_s.downcase
  end
end
