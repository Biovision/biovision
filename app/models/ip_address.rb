# frozen_string_literal: true

# IP address
#
# Attributes:
#   banned [boolean]
#   created_at [DateTime]
#   ip [inet]
#   object_count [integer]
#   updated_at [DateTime]
class IpAddress < ApplicationRecord
  include Toggleable

  toggleable :banned

  validates_uniqueness_of :ip

  scope :list_for_administration, -> { order('ip asc') }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end
end
