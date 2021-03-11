# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Handling user registration
      class RegistrationHandler
        attr_reader :user

        # @param [Biovision::Components::UsersComponent] component
        def initialize(component)
          @component = component
        end

        # @param [Hash] parameters
        # @param [Code|nil] Code
        def handle(parameters, code = nil)
          @user = User.new(parameters)
          @user.super_user = 1 if User.count < 1
          @user.code = code
          @code = code

          @component.use_invites? ? use_code : persist_user

          @user
        end

        # @param [Hash] parameters
        # @param [Code|nil] Code
        def check(parameters, code = nil)
          @user = User.new(parameters)
          @user.code = code
          @user.valid?
          add_code_error unless acceptable_code?
        end

        def open?
          @component.registration_open?
        end

        def valid?
          @user.errors.blank?
        end

        private

        def persist_user
          return unless @user.save

          metric = Biovision::Components::UsersComponent::METRIC_NEW_USER
          @component.register_metric(metric)

          Biovision::Components::UsersComponent.created_user(@user)
          handle_codes
        end

        def valid_invitation?
          @component.valid_invitation?(@code)
        end

        def acceptable_code?
          valid_invitation? || (@code.nil? && !@component.invite_only?)
        end

        # Check invitation code and persist user if it's valid
        def use_code
          acceptable_code? ? persist_user : add_code_error
        end

        def add_code_error
          @user.valid?
          @user.errors.add(:code, :invalid)
        end

        def handle_codes
          @component.send_email_confirmation(@user) if @component.confirm_email?
          @component.send_phone_confirmation(@user) if @component.confirm_phone?

          return unless @component.use_invites?

          @component.activate_invitation(@code, @user) if valid_invitation?
          @component.create_invitations_for_user(@user)
        end
      end
    end
  end
end
