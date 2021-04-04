# frozen_string_literal: true

module Biovision
  module Notifiers
    # Notification mapper for contact component
    class ContactNotifier < BaseNotifier
      TYPE_FEEDBACK_MESSAGE = 'feedback_message'

      # @param [Integer] message_id
      def new_feedback_message(message_id)
        check_and_notify(message_id, TYPE_FEEDBACK_MESSAGE)
      end
    end
  end
end
