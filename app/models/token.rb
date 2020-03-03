# frozen_string_literal: true

# Authentication token
#
# Attributes:
#   active [boolean]
#   agent_id [Agent], optional
#   created_at [DateTime]
#   ip_address_id [IpAddress], optional
#   last_used [datetime]
#   updated_at [DateTime]
#   user_id [User]
#   token [string]
class Token < ApplicationRecord
  include HasOwner

  has_secure_token

  belongs_to :user
  belongs_to :agent
  belongs_to :ip_address
end
