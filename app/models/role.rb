# frozen_string_literal: true

# ACL role
#
# Attributes:
#   biovision_component_id [BiovisionComponent]
#   data [jsonb]
#   slug [string]
#   user_count [integer]
#   uuid [uuid]
class Role < ApplicationRecord
  include Checkable
  include HasUuid

  SLUG_LIMIT = 50
  SLUG_PATTERN = /\A[a-z][_a-z]*[a-z]\z/.freeze

  belongs_to :biovision_component
  has_many :role_groups, dependent: :destroy
  has_many :user_groups, dependent: :destroy

  before_validation { self.slug = slug.to_s.downcase }

  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: :biovision_component_id
  validates_format_of :slug, with: SLUG_PATTERN

  # @param [String] slug
  def self.[](slug)
    find_by(slug: slug)
  end

  def groups
    # group_ids = role_groups.map(&:group).map(&:branch_ids).flatten.uniq
    # Group.where(id: group_ids)
    []
  end

  def users
    User.where(id: user_ids)
  end

  def user_ids
    # direct_inclusive = user_roles.where(inclusive: true).pluck(:user_id).uniq
    # direct_exclusive = user_roles.where(inclusive: false).pluck(:user_id).uniq
    # group_inclusive = groups.map(&:user_ids).flatten
    #
    # group_inclusive + direct_inclusive - direct_exclusive
    []
  end

  def count_users!
    self.user_count = user_ids.count
    save
  end
end
