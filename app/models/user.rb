# frozen_string_literal: true

# User
# 
# Attributes:
#   agent_id [Agent], optional
#   allow_mail [boolean]
#   balance [integer]
#   banned [boolean]
#   birthday [date], optional
#   bot [boolean]
#   consent [boolean]
#   created_at [DateTime]
#   data [jsonb]
#   deleted [boolean]
#   email [string], optional
#   email_confirmed [boolean]
#   foreign_slug [boolean]
#   image [UserImageUploader]
#   inviter_id [User], optional
#   ip_address_id [IpAddress], optional
#   language_id [Language], optional
#   last_seen [datetime], optional
#   notice [string], optional
#   password_digest [string]
#   phone_confirmed [boolean]
#   primary_id [User], optional
#   screen_name [string]
#   slug [string]
#   super_user [boolean]
#   phone [string], optional
#   referral_link [string]
#   updated_at [DateTime]
#   uuid [uuid]
class User < ApplicationRecord
  include HasUuid

  belongs_to :language
  belongs_to :agent
  belongs_to :ip_address
  has_secure_password
end
