# frozen_string_literal: true

# Role in ACL group
#
# Attributes:
#   group_id [Group]
#   role_id [Role]
class RoleGroup < ApplicationRecord
  belongs_to :group
  belongs_to :role

  validates_uniqueness_of :role_id, scope: :group_id
end
