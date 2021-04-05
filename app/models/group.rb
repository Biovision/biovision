# frozen_string_literal: true

# ACL group
#
# Attributes:
#   biovision_component_id [BiovisionComponent]
#   data [jsonb]
#   children_cache [Array<integer>]
#   parent_id [Group], optional
#   parents_cache [string]
#   slug [string]
#   user_count [Integer]
#   uuid [uuid]
class Group < ApplicationRecord
  include Checkable
  include HasUuid
  include TreeStructure

  SLUG_LIMIT = 50
  SLUG_PATTERN = /\A[a-z][_a-z]*[a-z]\z/.freeze

  belongs_to :biovision_component
  has_many :user_groups, dependent: :delete_all
  has_many :role_groups, dependent: :destroy

  before_validation { self.slug = slug.to_s.downcase }

  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: :biovision_component_id
  validates_format_of :slug, with: SLUG_PATTERN

  def roles
    Role.where(id: role_groups.where(group_id: branch_ids).pluck(:role_id).uniq)
  end

  def users
    User.where(id: user_ids)
  end

  def user_ids
    # user_groups.where(group_id: branch_ids).pluck(:user_id).uniq
    []
  end

  def users_changed!
    roles.each(&:count_users!)
  end
end
