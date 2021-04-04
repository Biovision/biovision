# frozen_string_literal: true

# Response to feedback message
#
# Attributes:
#   agent_id [Agent], optional
#   body [text]
#   created_at [DateTime]
#   data [jsonb]
#   feedback_message_id [FeedbackMessage]
#   ip_address_id [IpAddress], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [uuid]
#   visible [boolean]
class FeedbackResponse < ApplicationRecord
  include Checkable
  include HasOwner
  include HasTrack
  include HasUuid
  include Toggleable

  BODY_LIMIT = 5000

  toggleable :visible

  belongs_to :feedback_message
  belongs_to :user, optional: true

  validates_presence_of :body
  validates_length_of :body, maximum: BODY_LIMIT

  scope :recent, -> { order('id desc') }
  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, -> { recent }
  scope :list_for_visitors, -> { visible.recent }

  # @param [Integer] page
  def self.page_for_administration(page = 1)
    list_for_administration.page(page)
  end

  def self.entity_parameters
    %i[body]
  end

  def self.creation_parameters
    entity_parameters + %i[feedback_message_id]
  end
end
