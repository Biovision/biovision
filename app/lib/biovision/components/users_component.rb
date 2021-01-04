# frozen_string_literal: true

module Biovision
  module Components
    # Handling users
    class UsersComponent < BaseComponent
      include Users::Authentication

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

      # @param [User] entity
      def valid?(entity)
        entity.valid? && valid_slug?(entity)
      end

      def valid_slug?(entity)
        if settings['email_as_login']
          entity.slug =~ /\A[-_a-z0-9.]+@[-a-z0-9.]+\.[a-z]{2,24}\z/
        elsif entity.slug =~ /\A[_a-z0-9]{1,30}\z/
          true
        else
          key = 'activerecord.errors.models.user.attributes.slug.invalid'
          entity.errors[:slug] = t(key)
          false
        end
      end

      def registration_open?
        settings['registration_open']
      end
    end
  end
end
