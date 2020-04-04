# frozen_string_literal: true

# User agent
#
# Attributes:
#   banned [boolean]
#   browser_id [Browser], optional
#   created_at [DateTime]
#   object_count [integer]
#   name [string]
#   updated_at [DateTime]
class Agent < ApplicationRecord
  include RequiredUniqueName
  include Toggleable

  toggleable :banned

  belongs_to :browser, optional: true, counter_cache: true

  before_validation { self.name = name.to_s[0..254] }

  scope :list_for_administration, -> { ordered_by_name }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  # @param [String] name
  def self.[](name)
    return if name.blank?

    find_or_create_by(name: name[0..254])
  end
end
