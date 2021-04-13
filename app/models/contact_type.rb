# frozen_string_literal: true

# Type of contact
#
# Attributes:
#   slug [String]
class ContactType < ApplicationRecord
  include Checkable
  include RequiredUniqueSlug

  SLUG_PATTERN = /\A[a-z][_a-z]{,16}[a-z]\z/.freeze

  has_many :contact_methods, dependent: :delete_all

  validates_format_of :slug, with: SLUG_PATTERN

  scope :list_for_administration, -> { ordered_by_slug }

  # @param [String] slug
  def self.[](slug)
    find_by(slug: slug)
  end

  def self.entity_parameters(*)
    %i[slug]
  end
end
