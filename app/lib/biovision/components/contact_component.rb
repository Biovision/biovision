# frozen_string_literal: true

module Biovision
  module Components
    # Contact and feedback
    class ContactComponent < BaseComponent
      SETTING_FEEDBACK_MAIL = 'feedback_email'

      def self.settings_strings
        [SETTING_FEEDBACK_MAIL]
      end

      def self.default_settings
        { feedback_email: '' }
      end

      def self.dependent_models
        [FeedbackMessage, FeedbackResponse, ContactType, ContactMethod]
      end

      def use_parameters?
        true
      end

      def administrative_parts
        []
      end
    end
  end
end
