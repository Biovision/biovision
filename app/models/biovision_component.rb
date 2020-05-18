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

  has_many :biovision_component_users, dependent: :delete_all
  has_many :simple_images, dependent: :destroy

  scope :list_for_administration, -> { ordered_by_priority }

  # Find component by slug
  #
  # @param [String] slug
  def self.[](slug)
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
end
