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

  CACHE_KEY = 'role_cache'

  belongs_to :biovision_component
  has_many :role_groups, dependent: :destroy
  has_many :user_roles, dependent: :destroy

  before_validation { self.slug = slug.to_s.downcase }

  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: :biovision_component_id

  # @param [String] slug
  def self.[](slug)
    parts = slug.to_s.split('.')
    criteria = {
      biovision_components: { slug: parts.shift },
      slug: parts.join('.')
    }
    joins(:biovision_component).where(criteria).first
  end

  def groups
    # group_ids = role_groups.map(&:group).map(&:branch_ids).flatten.uniq
    # Group.where(id: group_ids)
    []
  end

  def users
    User.where("data->'role_cache' @> '[?]'::jsonb", id)
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

  # @param [User] user
  def add_to_cache!(user)
    return if user.nil?

    ids = user.role_ids + [id]
    user.data[CACHE_KEY] = ids.uniq
    user.save
  end

  # @param [User] user
  def remove_from_cache!(user)
    return if user.nil?

    new_ids = user.role_ids - [id]
    user.data[CACHE_KEY] = new_ids
    user.save
  end

  # @param [User] user
  # @param [Hash] options
  def add_user(user, options = { inclusive: true })
    inclusive = !options[:inclusive].blank?

    user_roles.create(user: user, inclusive: inclusive)
    inclusive ? add_to_cache!(user) : remove_from_cache!(user)
  end

  # @param [User] user
  def remove_user(user)
    return if user.nil?

    user_roles.where(user: user).destroy_all
    remove_from_cache!(user)
  end
end
