# frozen_string_literal: true

# Code for users
# 
# Attributes:
#   agent_id [Agent], optional
#   biovision_component_id [BiovisionComponent]
#   body [string]
#   created_at [DateTime]
#   data [jsonb]
#   ip_address_id [IpAddress], optional
#   quantity [integer]
#   updated_at [DateTime]
#   user_id [User]
class Code < ApplicationRecord
  include HasOwner

  belongs_to :biovision_component
  belongs_to :user
  belongs_to :agent
  belongs_to :ip_address
end
