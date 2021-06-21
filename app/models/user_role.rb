# frozen_string_literal: true

# ACL role for user
#
# Attributes:
#   created_at [DateTime]
#   role_id [Role]
#   updated_at [DateTime]
#   user_id [User]
class UserRole < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates_uniqueness_of :role_id, scope: :user_id

  after_create { role.count_users! }
  after_destroy { role.count_users! }
end
