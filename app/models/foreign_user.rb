# frozen_string_literal: true

# Foreign user
# 
# Attributes:
#   agent_id [Agent], optional
#   created_at [DateTime]
#   data [jsonb]
#   foreign_site_id [ForeignSite]
#   ip_address_id [IpAddress], optional
#   updated_at [DateTime]
#   user_id [User]
#   slug [string]
class ForeignUser < ApplicationRecord
  include HasOwner

  belongs_to :foreign_site
  belongs_to :user
  belongs_to :agent
  belongs_to :ip_address
end
