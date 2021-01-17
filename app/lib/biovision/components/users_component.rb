# frozen_string_literal: true

module Biovision
  module Components
    # Handling users
    class UsersComponent < BaseComponent
      include Users::Authentication
      include Users::Validation

      CODE_CONFIRMATION = 'confirmation'
      CODE_INVITATION = 'invitation'
      METRIC_AUTH_FAILURE = 'users.auth.failure.hit'
      METRIC_NEW_USER = 'users.new_user.hit'
      METRIC_REGISTRATION_BOT = 'users.registration.bot.hit'
      METRIC_USED_INVITATION = 'users.used_invitation.hit'

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
        handler = new(BiovisionComponent[slug], user)

        return unless handler.use_invites?

        parameters = {
          user: user,
          quantity: handler.settings['invite_count'].to_i
        }

        code = handler.component.codes.new(parameters)
        code.code_type = CODE_INVITATION
        code.save
      end

      # @param [Hash] parameters
      # @param [Code] code
      def register_user(parameters, code)
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

      def registration_open?
        settings['registration_open']
      end

      def email_as_login?
        settings['email_as_login']
      end

      def require_email?
        settings['require_email'] || email_as_login?
      end

      def invite_only?
        settings['invite_only']
      end

      def use_invites?
        settings['use_invites'] || invite_only?
      end
    end
  end
end
