# frozen_string_literal: true

module Biovision
  module Components
    # Contact and feedback
    class ContactComponent < BaseComponent
      def self.settings_strings
        %w[feedback_email]
      end

      def use_parameters?
        true
      end
    end
  end
end
