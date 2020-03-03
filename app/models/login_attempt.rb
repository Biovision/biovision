# frozen_string_literal: true

# Failed login attempt
# 
# Attributes:
#   agent_id [Agent], optional
#   created_at [DateTime]
#   ip_address_id [IpAddress], optional
#   updated_at [DateTime]
#   user_id [User]
#   password [string]
class LoginAttempt < ApplicationRecord
  include HasOwner

  belongs_to :user
  belongs_to :agent
  belongs_to :ip_address
end
