# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Handling user registration
      class RegistrationHandler
        # @param [Biovision::Components::UsersComponent] component
        def initialize(component)
          @component = component
        end

        def handle(parameters, code = nil)
          @user = User.new(parameters)
          @user.screen_name = @user.email if email_as_login?
          @manager = CodeHandler.new(@component, code)

          use_invites? ? use_code : persist_user
          persist_user if @component.valid?(@user)

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

        def email_as_login?
          @component.settings['email_as_login']
        end

        def require_email?
          @component.settings['require_email'] || email_as_login?
        end

        protected

        def persist_user
          return unless @user.save

          metric = Biovision::Components::UsersComponent::METRIC_NEW_USER
          @component.register_metric(metric)

          # handle_codes
        end

        # Check invitation code and persist user if it's valid
        def use_code
          if @manager.valid? || (@manager.code.nil? && !invite_only?)
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
            code = CodeManager::Confirmation.code_for_user(@user)
            CodeSender.email(code.id).deliver_later
          end

          return unless use_invites?

          @manager.activate(@user) if @manager.valid?
          create_invitations(settings['invite_count'].to_i)
        end

        # @param [Integer] quantity
        def create_invitations(quantity = 1)
          return unless quantity.positive?

          parameters = {
            code_type: CodeManager::Invitation.code_type,
            user: @user,
            quantity: quantity
          }
          Code.create(parameters)
        end
      end
    end
  end
end
