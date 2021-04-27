# frozen_string_literal: true

# Mailer for sending feedback requests
class FeedbackMailer < ApplicationMailer
  # @param [Integer] id
  def new_feedback_request(id)
    @entity = FeedbackMessage.find_by(id: id)

    key = Biovision::Components::ContactComponent::SETTING_FEEDBACK_MAIL
    receiver = Biovision::Components::ContactComponent[nil].settings[key]

    mail to: receiver unless @entity.nil? || receiver.blank?
  end
end
