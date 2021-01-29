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
        def valid_confirmation?(code)
          return false if code.nil? || code.biovision_component != @component
          return false unless code.active?

          code_type = self.class::CODE_CONFIRMATION
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
        def create_confirmation(user)
          code = @component.codes.new(user: user)
          code.code_type = code_type
          code.data['email'] = user.email
          code.save
          code
        end

        # @param [User] user
        def send_confirmation(user)
          code_type = self.class::CODE_CONFIRMATION
          codes = @component.codes.active.owned_by(user).with_type(code_type)
          code = codes.find_by("data->>'email' = ?", user.email)
          code = create_confirmation(user) if code.nil?

          CodeSender.email(code.id).deliver_later
        end

        # @param [Code] code
        def activate_confirmation(code)
          code.user.update(email_confirmed: true) if valid_confirmation?(code)
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
