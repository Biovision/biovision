# frozen_string_literal: true

# Foreign site for external authentication
# 
# Attributes:
#   slug [string]
#   name [string]
#   foreign_users_count [integer]
class ForeignSite < ApplicationRecord
  include RequiredUniqueName
  include RequiredUniqueSlug

  NAME_LIMIT = 50
  SLUG_LIMIT = 50

  has_many :foreign_users, dependent: :delete_all

  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT

  scope :list_for_administration, -> { ordered_by_name }

  # @param [String] slug
  def self.[](slug)
    find_by(slug: slug)
  end

  # @param [Hash] data
  # @param [Hash] tracking
  def authenticate(data, tracking)
    user = foreign_users.find_by(slug: data[:uid])&.user
    user || create_user(data, tracking)
  end
end
