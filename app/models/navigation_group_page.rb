# frozen_string_literal: true

# Page in navigation group
#
# Attributes:
#   created_at [DateTime]
#   dynamic_page_id [DynamicPage]
#   navigation_group_id [NavigationGroup]
#   priority [integer]
#   updated_at [DateTime]
class NavigationGroupPage < ApplicationRecord
  include NestedPriority

  belongs_to :navigation_group, counter_cache: :dynamic_pages_count
  belongs_to :dynamic_page

  validates_uniqueness_of :dynamic_page_id, scope: :navigation_group_id

  # @param [NavigationGroupPage] entity
  def self.siblings(entity)
    where(navigation_group_id: entity&.navigation_group_id)
  end
end
