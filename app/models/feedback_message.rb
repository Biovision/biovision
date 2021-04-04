# frozen_string_literal: true

# Message from visitor
#
# Attributes:
#   agent_id [Agent], optional
#   attachment [SimpleFileUploader], optional
#   comment [text], optional
#   created_at [DateTime]
#   data [jsonb]
#   email [string], optional
#   ip_address_id [IpAddress], optional
#   language_id [Language], optional
#   name [string], optional
#   phone [string], optional
#   processed [boolean]
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [uuid]
class FeedbackMessage < ApplicationRecord
  include Checkable
  include HasLanguage
  include HasOwner
  include HasTrack
  include HasUuid
  include Toggleable

  COMMENT_LIMIT = 5000
  EMAIL_LIMIT = 250
  EMAIL_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z0-9][-a-z0-9]+)\z/i.freeze
  NAME_LIMIT = 100
  PHONE_LIMIT = 30

  toggleable :processed

  mount_uploader :attachment, SimpleFileUploader

  belongs_to :user, optional: true
  has_many :feedback_responses, dependent: :delete_all

  validates_format_of :email, with: EMAIL_PATTERN, allow_blank: true
  validates_length_of :comment, maximum: COMMENT_LIMIT
  validates_length_of :email, maximum: EMAIL_LIMIT
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :phone, maximum: PHONE_LIMIT

  scope :recent, -> { order('id desc') }
  scope :unprocessed, -> { where(processed: false) }
  scope :list_for_administration, -> { recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[attachment comment email language_id name phone]
  end
end
