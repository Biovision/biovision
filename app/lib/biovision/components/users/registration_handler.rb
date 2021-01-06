# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Handling user registration
      class RegistrationHandler
        CODE_CONFIRMATION = 'confirmation'
        CODE_INVITATION = 'invitation'

        # @param [Biovision::Components::UsersComponent] component
        def initialize(component)
          @component = component
        end

        # @param [Hash] parameters
        # @param [Code|nil] Code
        def handle(parameters, code = nil)
          @user = User.new(parameters)
          @user.super_user = 1 if User.count < 1
          @code = code

          use_invites? ? use_code : persist_user

          @user
        end

        def open?
          @component.settings['registration_open']
        end

        def invite_only?
          @component.settings['invite_only']
        end

        def use_invites?
          @component.settings['use_invites'] || invite_only?
        end

        def confirm_email?
          @component.settings['confirm_email']
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

          @code.type?(CODE_INVITATION) && @code.active?
        end

        # Check invitation code and persist user if it's valid
        def use_code
          if valid_invitation? || (@code.nil? && !invite_only?)
            persist_user
          else
            error = I18n.t('biovision.components.users.messages.invalid_code')

            # Add "invalid code" error to other model errors, if any
            @user.valid?
            @user.errors.add(:code, error)
          end
        end

        def handle_codes
          if confirm_email?
            code = @component.find_or_create_code(@user, CODE_CONFIRMATION)
            CodeSender.email(code.id).deliver_later
          end

          return unless use_invites?

          activate_invitation if valid_invitation?
        end

        def activate_invitation
          return if @code.nil? || !@code.active?

          @code.decrement!(:quantity)
          @user.update(inviter_id: @code.user_id)
        end
      end
    end
  end
end
