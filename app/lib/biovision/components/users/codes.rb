# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Handling user-related codes
      module Codes
        # @param [Code] code
        # @param [String] code_type
        def valid_code?(code, code_type)
          return false if code.nil? || code.biovision_component != @component

          code.type?(code_type) && code.active?
        end

        # @param [Code] code
        def valid_email_confirmation?(code)
          return false if code.nil? || code.biovision_component != @component
          return false unless code.active?

          code_type = self.class::CODE_EMAIL_CONFIRMATION
          code.type?(code_type) && code.data['email'] == user.email
        end

        # @param [Code] code
        def valid_invitation?(code)
          valid_code?(code, self.class::CODE_INVITATION)
        end

        # @param [Code] code
        def valid_recovery?(code)
          valid_code?(code, self.class::CODE_RECOVERY)
        end

        # @param [User] user
        def create_email_confirmation(user)
          code_type = self.class::CODE_EMAIL_CONFIRMATION
          code = @component.codes.new(user: user, code_type: code_type)
          code.data['email'] = user.email
          code.save
          code
        end

        # @param [User] user
        def create_phone_confirmation(user)
          code_type = self.class::CODE_PHONE_CONFIRMATION
          code = @component.codes.new(user: user, code_type: code_type)
          code.data['phone'] = user.phone
          code.save
          code
        end

        # @param [User] user
        def send_email_confirmation(user)
          code_type = self.class::CODE_EMAIL_CONFIRMATION
          codes = @component.codes.active.owned_by(user).with_type(code_type)
          code = codes.find_by("data->>'email' = ?", user.email)
          code = create_email_confirmation(user) if code.nil?

          CodeSender.email(code.id).deliver_later
        end

        # @param [User] user
        def send_phone_confirmation(user)
          code_type = self.class::CODE_PHONE_CONFIRMATION
          codes = @component.codes.active.owned_by(user).with_type(code_type)
          code = codes.find_by("data->>'phone' = ?", user.email)
          code = create_phone_confirmation(user) if code.nil?

          SendPhoneConfirmationJob.perform_later(code.id)
        end

        # @param [Code] code
        def activate_email_confirmation(code)
          return unless valid_email_confirmation?(code)

          code.user.update(email_confirmed: true)
        end

        # @param [Code] code
        # @param [User] user
        def activate_invitation(code, user)
          return if code.nil? || !code.active? || user.nil?

          code.decrement!(:quantity)
          user.update(inviter_id: code.user_id)

          register_metric(self.class::METRIC_USED_INVITATION)
        end

        # @param [User] user
        def create_invitations_for_user(user)
          quantity = settings[self.class::SETTING_INVITE_COUNT].to_i

          return if quantity < 1

          code = @component.codes.new(user: user, quantity: quantity)
          code.code_type = self.class::CODE_INVITATION
          code.save
        end
      end
    end
  end
end
