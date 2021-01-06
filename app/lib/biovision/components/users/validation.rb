# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Validating instances of User
      module Validation
        def validate
          prepare_screen_name if user.new_record?

          validate_email_presence if require_email? || user.email_as_login?
          validate_email_format unless user.email.blank?
          validate_screen_name unless user.data['skip_screen_name_validation']
        end

        private

        def prepare_screen_name
          return unless email_as_login?

          user.data['email_as_login'] = true
          user.screen_name = user.uuid
        end

        def validate_email_presence
          user.errors.add(:email, :blank) if user.email.blank?
        end

        def validate_email_format
          too_long = user.email.to_s.length > User::EMAIL_LIMIT
          pattern_matches = (user.email.to_s =~ User::EMAIL_PATTERN)

          user.errors.add(:email, :invalid) if too_long || !pattern_matches
        end

        def validate_screen_name
          pattern = User::SLUG_PATTERN

          return if user.screen_name =~ pattern

          user.errors.add(:screen_name, :invalid)
        end
      end
    end
  end
end