# frozen_string_literal: true

# Dynamic block
#
# Attributes:
#   body [Text], optional
#   created_at [DateTime]
#   data [JSON]
#   slug [String]
#   updated_at [DateTime]
#   visible [Boolean]
class DynamicBlock < ApplicationRecord
  include Checkable
  include RequiredUniqueSlug
  include Toggleable

  SLUG_LIMIT = 100

  toggleable :visible

  validates_length_of :slug, maximum: SLUG_LIMIT

  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, -> { ordered_by_slug }

  # Get body of visible block with given slug or empty string
  #
  # Can be used in views for quick output
  #
  # @param [String] slug
  # @return [String]
  def self.[](slug)
    visible.find_by(slug: slug)&.body.to_s
  end

  def self.entity_parameters
    %i[body slug visible]
  end

  def text_for_link
    slug
  end
end
