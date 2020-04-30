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
  belongs_to :user

  after_initialize :generate_body

  before_validation :sanitize_quantity

  validates_presence_of :body
  validates_uniqueness_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  scope :recent, -> { order('id desc') }
  scope :active, -> { where('quantity > 0') }
  scope :list_for_administration, -> { recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[body payload quantity]
  end

  def self.creation_parameters
    entity_parameters + %i[user_id code_type_id]
  end

  def activated?
    quantity < 1
  end

  def active?
    quantity.positive?
  end

  private

  def generate_body
    return unless body.nil?

    number = SecureRandom.random_number(0xffff_ffff_ffff_ffff)
    self.body = number.to_s(36).scan(/.{4}/).join('-').upcase
  end

  def sanitize_quantity
    self.quantity = QUANTITY_RANGE.first if quantity < QUANTITY_RANGE.first
    self.quantity = QUANTITY_RANGE.last if quantity > QUANTITY_RANGE.last
  end
end
