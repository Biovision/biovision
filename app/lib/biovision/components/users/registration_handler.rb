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
          key = Biovision::Components::UsersComponent::SETTING_OPEN
          @component.settings[key]
        end

        def confirm_email?
          key = Biovision::Components::UsersComponent::SETTING_CONFIRM_EMAIL
          @component.settings[key]
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
          return false if @code.nil?

          code_type = Biovision::Components::UsersComponent::CODE_INVITATION
          @code.type?(code_type) && @code.active?
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
          if confirm_email?
            code_type = Biovision::Components::UsersComponent::CODE_CONFIRMATION
            code = @component.find_or_create_code(@user, code_type)
            CodeSender.email(code.id).deliver_later
          end

          return unless @component.use_invites?

          activate_invitation if valid_invitation?
        end

        def activate_invitation
          return if @code.nil? || !@code.active?

          @code.decrement!(:quantity)
          @user.update(inviter_id: @code.user_id)

          metric = Biovision::Components::UsersComponent::METRIC_USED_INVITATION
          @component.register_metric(metric)
        end
      end
    end
  end
end
