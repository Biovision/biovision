# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Helper methods for checking user flags
      module FlagHelpers
        def needs_email_confirmation?
          return false if user&.email_confirmed?

          confirm_email? && !user.email.blank?
        end

        def needs_phone_confirmation?
          return false if user&.phone_confirmed?

          confirm_phone? && !user.phone.blank?
        end

        def registration_open?
          key = Biovision::Components::UsersComponent::SETTING_OPEN
          settings[key]
        end

        def email_as_login?
          key = Biovision::Components::UsersComponent::SETTING_EMAIL_AS_LOGIN
          settings[key]
        end

        def phone_as_login?
          key = Biovision::Components::UsersComponent::SETTING_PHONE_AS_LOGIN
          settings[key]
        end

        def require_email?
          key = Biovision::Components::UsersComponent::SETTING_REQUIRE_EMAIL
          settings[key] || email_as_login?
        end

        def require_phone?
          key = Biovision::Components::UsersComponent::SETTING_REQUIRE_PHONE
          settings[key] || phone_as_login?
        end

        def confirm_email?
          key = Biovision::Components::UsersComponent::SETTING_CONFIRM_EMAIL
          settings[key]
        end

        def confirm_phone?
          key = Biovision::Components::UsersComponent::SETTING_CONFIRM_PHONE
          settings[key]
        end

        def invite_only?
          key = Biovision::Components::UsersComponent::SETTING_INVITE_ONLY
          settings[key]
        end

        def use_invites?
          key = Biovision::Components::UsersComponent::SETTING_USE_INVITES
          settings[key] || invite_only?
        end

        def use_phone?
          key = Biovision::Components::UsersComponent::SETTING_USE_PHONE
          settings[key]
        end
      end
    end
  end
end