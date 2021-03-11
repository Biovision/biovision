# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Validating instances of User
      module Validation
        def validate
          prepare_screen_name if user.new_record?

          validate_email
          validate_phone
          validate_screen_name unless user.data[User::FLAG_SKIP_SCREEN_NAME]
        end

        private

        def prepare_screen_name
          use_uuid = false
          use_uuid = email_as_login! if email_as_login?
          use_uuid = phone_as_login! if phone_as_login?

          user.screen_name = user.uuid if use_uuid
        end

        def email_as_login!
          key = Biovision::Components::UsersComponent::SETTING_EMAIL_AS_LOGIN
          user.data[key] = true
        end

        def phone_as_login!
          key = Biovision::Components::UsersComponent::SETTING_PHONE_AS_LOGIN
          user.data[key] = true
        end

        def validate_phone
          user.errors.add(:phone, :blank) if require_phone? && user.phone.blank?

          normalize_phone_format
          validate_phone_format unless user.phone.blank?
        end

        def normalize_phone_format
          has_plus = user.phone.strip[0] == '+'
          normalized_phone = user.phone.gsub(/\D/, '')
          normalized_phone[0] = '7' if !has_plus && normalized_phone[0] == '8'

          user.phone = "+#{normalized_phone}" unless normalized_phone.blank?
        end

        # @see https://ru.wikipedia.org/wiki/MSISDN
        def validate_phone_format
          return if user.phone =~ /\+\d{11,15}/

          user.errors.add(:phone, :invalid)
        end

        def validate_email
          user.errors.add(:email, :blank) if require_email? && user.email.blank?

          validate_email_format unless user.email.blank?
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
