# frozen_string_literal: true

# User in ACL group
#
# Attributes:
#   created_at [DateTime]
#   group_id [Group]
#   updated_at [DateTime]
#   user_id [User]
class UserGroup < ApplicationRecord
  include HasOwner

  belongs_to :user
  belongs_to :group, counter_cache: :user_count

  validates_uniqueness_of :group_id, scope: :user_id

  after_create { group.users_changed! }
  after_destroy { group.users_changed! }
end
