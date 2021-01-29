# frozen_string_literal: true

# Biovision component entity, settings and parameters
#
# Attributes:
#   active [Boolean]
#   created_at [DateTime]
#   parameters [JSON]
#   priority [Integer]
#   settings [JSON]
#   slug [String]
#   updated_at [DateTime]
class BiovisionComponent < ApplicationRecord
  include FlatPriority
  include RequiredUniqueSlug

  SLUG_LIMIT = 250
  SLUG_PATTERN_HTML = '^[a-zA-Z][-a-zA-Z0-9_]+[a-zA-Z0-9]$'

  has_many :biovision_component_users, dependent: :delete_all
  has_many :simple_images, dependent: :destroy
  has_many :codes, dependent: :delete_all

  scope :active, -> { where(active: true) }
  scope :list_for_administration, -> { ordered_by_priority }

  # Find component by slug
  #
  # @param [String|Biovision::Components::BaseComponent] slug
  def self.[](slug)
    slug = slug.slug if slug.is_a? Biovision::Components::BaseComponent
    find_by(slug: slug)
  end

  # @param [String] slug
  # @param [String] default_value
  def get(slug, default_value = '')
    parameters.fetch(slug.to_s) { default_value }
  end

  # @param [String] slug
  # @param value
  def []=(slug, value)
    parameters[slug.to_s] = value
    save!
  end

  def privileges
    biovision_component_users.recent
  end

  # @param [User] user
  # @param [String] type
  # @param [Integer] quantity
  def find_or_create_code(user, type, quantity = 1)
    code = codes.owned_by(user).with_type(type).active.first

    if code.nil?
      code = codes.new(user: user, quantity: quantity)
      code.code_type = type
      code.save
    end

    code
  end
end
