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
  include HasTrack

  belongs_to :user

  before_validation { self.password = password.to_s[0..254] }

  scope :recent, -> { order('id desc') }
  scope :since, ->(time) { where('created_at > ?', time) }
  scope :list_for_administration, -> { recent }
  scope :list_for_owner, ->(u) { owned_by(u).recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  # @param [User] user
  # @param [Integer] page
  def self.page_for_owner(user, page = 1)
    list_for_owner(user).page(page)
  end
end
