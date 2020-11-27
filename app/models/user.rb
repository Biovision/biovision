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
#   image [SimpleImageUploader]
#   inviter_id [User], optional
#   ip_address_id [IpAddress], optional
#   language_id [Language], optional
#   last_seen [datetime], optional
#   notice [string], optional
#   password_digest [string]
#   phone_confirmed [boolean]
#   primary_id [User], optional
#   profile [Jsonb]
#   screen_name [string]
#   slug [string]
#   super_user [boolean]
#   phone [string], optional
#   referral_link [string]
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
  NOTICE_LIMIT = 255
  PHONE_LIMIT = 50
  SLUG_LIMIT = 250

  toggleable :banned, :allow_mail, :email_confirmed, :phone_confirmed

  has_secure_password
  mount_uploader :image, SimpleImageUploader

  belongs_to :inviter, class_name: User.to_s, optional: true
  has_many :invitees, class_name: User.to_s, foreign_key: :inviter_id, dependent: :nullify
  has_many :tokens, dependent: :delete_all
  has_many :codes, dependent: :delete_all
  has_many :foreign_users, dependent: :delete_all if Gem.loaded_specs.key?('biovision-oauth')
  has_many :login_attempts, dependent: :delete_all
  has_many :user_languages, dependent: :delete_all

  before_validation :normalize_slug

  validates_acceptance_of :consent
  validates_presence_of :screen_name
  validates_format_of :email, with: EMAIL_PATTERN, allow_blank: true
  validates :screen_name, uniqueness: { case_sensitive: false }
  validates :email, uniqueness: { case_sensitive: false }, allow_nil: true
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :screen_name, maximum: SLUG_LIMIT
  validates_length_of :email, maximum: EMAIL_LIMIT
  validates_length_of :phone, maximum: PHONE_LIMIT
  validates_length_of :notice, maximum: NOTICE_LIMIT

  scope :bots, ->(f) { where(bot: f.to_i.positive?) unless f.blank? }
  scope :email_like, ->(v) { where('email ilike ?', "%#{v}%") unless v.blank? }
  scope :with_email, ->(v) { where('lower(email) = lower(?)', v) }

  def self.profile_parameters
    %i[image allow_mail birthday consent]
  end

  def self.sensitive_parameters
    %i[email phone password password_confirmation]
  end

  # Параметры при регистрации
  def self.new_profile_parameters
    profile_parameters + sensitive_parameters + %i[screen_name]
  end

  # Administrative parameters
  def self.entity_parameters
    flags = %i[banned bot email_confirmed phone_confirmed foreign_slug]

    new_profile_parameters + flags + %i[screen_name notice balance]
  end

  def self.ids_range
    min = User.minimum(:id).to_i
    max = User.maximum(:id).to_i
    (min..max)
  end

  # Name to be shown as profile
  #
  # This can be redefined for cases when something other than screen name should
  # be used.
  #
  # @return [String]
  def profile_name
    screen_name
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

  private

  def normalize_slug
    self.slug = screen_name.to_s if slug.nil?
    self.slug = slug.to_s.downcase
  end
end
