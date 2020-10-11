# frozen_string_literal: true

# Navigation group
#
# Attributes:
#   created_at [DateTime]
#   dynamic_pages_count [integer]
#   name [string]
#   slug [string]
#   updated_at [DateTime]
class NavigationGroup < ApplicationRecord
  include Checkable
  include RequiredUniqueName
  include RequiredUniqueSlug

  NAME_LIMIT = 100
  SLUG_LIMIT = 100

  has_many :navigation_group_pages, dependent: :delete_all

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT

  scope :list_for_administration, -> { ordered_by_name }

  def self.entity_parameters
    %i[name slug]
  end

  def text_for_link
    name
  end
end
