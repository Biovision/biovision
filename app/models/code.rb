# frozen_string_literal: true

# Code for users
#
# Attributes:
#   agent_id [Agent], optional
#   biovision_component_id [BiovisionComponent]
#   body [string]
#   created_at [DateTime]
#   data [jsonb]
#   ip_address_id [IpAddress], optional
#   quantity [integer]
#   updated_at [DateTime]
#   user_id [User]
class Code < ApplicationRecord
  include HasOwner
  include HasTrack

  BODY_LIMIT = 50
  QUANTITY_RANGE = (0..32_767).freeze

  belongs_to :biovision_component
  belongs_to :user, optional: true

  after_initialize :generate_body

  before_validation :sanitize_quantity

  validates_presence_of :body
  validates_uniqueness_of :body, unless: :phone?
  validates_length_of :body, maximum: BODY_LIMIT

  scope :recent, -> { order('id desc') }
  scope :active, -> { where('quantity > 0') }
  scope :with_type, ->(v) { where("data->>'type' = ?", v) unless v.blank? }
  scope :list_for_administration, -> { recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters(*)
    %i[body quantity]
  end

  def self.creation_parameters(*)
    entity_parameters + %i[user_id biovision_component_id]
  end

  def activated?
    quantity < 1
  end

  def active?
    quantity.positive?
  end

  # @param [String] type_name
  def type?(type_name)
    code_type == type_name.to_s
  end

  def code_type
    data['type'].to_s
  end

  # @param [String] new_type
  def code_type=(new_type)
    data['type'] = new_type.to_s
  end

  def phone?
    type?(Biovision::Components::UsersComponent::CODE_PHONE_CONFIRMATION)
  end

  private

  def generate_body
    return unless body.nil?

    if phone?
      number = SecureRandom.random_number(0xffff_ffff_ffff_ffff)
      self.body = number.to_s(36).scan(/.{4}/).join('-').upcase
    else
      self.body = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
    end
  end

  def sanitize_quantity
    self.quantity = QUANTITY_RANGE.first if quantity < QUANTITY_RANGE.first
    self.quantity = QUANTITY_RANGE.last if quantity > QUANTITY_RANGE.last
  end
end
