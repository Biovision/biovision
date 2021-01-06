# frozen_string_literal: true

module Biovision
  module Components
    # Handling users
    class UsersComponent < BaseComponent
      include Users::Authentication
      include Users::Validation

      METRIC_NEW_USER = 'users.new_user.hit'
      METRIC_AUTH_FAILURE = 'users.auth.failure.hit'
      METRIC_REGISTRATION_BOT = 'users.registration.bot.hit'

      def self.settings_flags
        %w[
          registration_open email_as_login confirm_email require_email
          invite_only use_invites
        ]
      end

      def self.settings_numbers
        %w[invite_count bounce_count bounce_timeout]
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
        component = BiovisionComponent[slug]

        return unless component.settings['use_invites']

        parameters = { user: user, quantity: quantity }

        code = component.codes.new(parameters)
        code.code_type = CODE_INVITATION
        code.save
      end

      # @param [Hash] parameters
      # @param [Code] code
      def register_user(parameters, code)
        handler = Users::RegistrationHandler.new(self)
        handler.handle(parameters, code)
      end

      def registration_open?
        settings['registration_open']
      end

      def email_as_login?
        settings['email_as_login']
      end

      def require_email?
        settings['require_email'] || email_as_login?
      end
    end
  end
end
