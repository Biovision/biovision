# frozen_string_literal: true

module Biovision
  module Components
    # Handling users
    class UsersComponent < BaseComponent
      include Users::Authentication
      include Users::Validation
      include Users::Codes
      include Users::FlagHelpers

      CODE_EMAIL_CONFIRMATION = 'email_confirmation'
      CODE_INVITATION = 'invitation'
      CODE_PHONE_CONFIRMATION = 'phone_confirmation'
      CODE_RECOVERY = 'recovery'
      METRIC_AUTH_FAILURE = 'users.auth.failure.hit'
      METRIC_NEW_USER = 'users.new_user.hit'
      METRIC_REGISTRATION_BOT = 'users.registration.bot.hit'
      METRIC_USED_INVITATION = 'users.used_invitation.hit'
      SETTING_BOUNCE_COUNT = 'bounce_count'
      SETTING_BOUNCE_TIMEOUT = 'bounce_timeout'
      SETTING_CONFIRM_EMAIL = 'confirm_email'
      SETTING_CONFIRM_PHONE = 'confirm_phone'
      SETTING_EMAIL_AS_LOGIN = 'email_as_login'
      SETTING_INVITE_COUNT = 'invite_count'
      SETTING_INVITE_ONLY = 'invite_only'
      SETTING_OPEN = 'registration_open'
      SETTING_PHONE_AS_LOGIN = 'phone_as_login'
      SETTING_REQUIRE_EMAIL = 'require_email'
      SETTING_REQUIRE_PHONE = 'require_phone'
      SETTING_USE_INVITES = 'use_invites'
      SETTING_USE_PHONE = 'use_phone'

      def self.settings_flags
        [
          SETTING_OPEN, SETTING_EMAIL_AS_LOGIN, SETTING_CONFIRM_EMAIL,
          SETTING_CONFIRM_PHONE, SETTING_PHONE_AS_LOGIN, SETTING_REQUIRE_EMAIL,
          SETTING_REQUIRE_PHONE, SETTING_INVITE_ONLY, SETTING_USE_INVITES,
          SETTING_USE_PHONE
        ]
      end

      def self.settings_numbers
        [SETTING_INVITE_COUNT, SETTING_BOUNCE_COUNT, SETTING_BOUNCE_TIMEOUT]
      end

      # @param [User] user
      def self.created_user(user)
        BiovisionComponent.active.pluck(:slug).each do |slug|
          handler = Biovision::Components::BaseComponent.handler_class(slug)
          handler.handle_new_user(user) if handler.respond_to?(:handle_new_user)
        end
      end

      # @param [User] user
      def self.handle_new_user(user)
        handler = new(BiovisionComponent[slug], user)

        return unless handler.use_invites?

        parameters = {
          user: user,
          quantity: handler.settings[SETTING_INVITE_COUNT].to_i
        }

        code = handler.component.codes.new(parameters)
        code.code_type = CODE_INVITATION
        code.save
      end

      # @param [Hash] parameters
      # @param [Code|nil] code
      def register_user(parameters, code = nil)
        handler = Users::RegistrationHandler.new(self)
        handler.handle(parameters, code)
      end

      # @param [Hash] user_data
      # @param [Hash] profile_data
      def create_user(user_data, profile_data)
        handler = Users::ProfileHandler.new(self)
        handler.create(user_data, profile_data)
        handler.user
      end

      # @param [User] user
      # @param [Hash] user_data
      # @param [Hash] profile_data
      def update_user(user, user_data, profile_data)
        handler = Users::ProfileHandler.new(self)
        handler.user = user
        handler.update(user_data, profile_data)
      end

      # @param [String|Symbol] attribute_name
      def attribute(attribute_name)
        return nil if user.nil?

        user.attributes[attribute_name.to_s]
      end
    end
  end
end
