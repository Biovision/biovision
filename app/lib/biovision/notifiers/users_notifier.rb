# frozen_string_literal: true

module Biovision
  module Notifiers
    # Notification mapper for socialization component
    class UsersNotifier < BaseNotifier
      TYPE_LOGIN_ATTEMPT = 'login_attempt'

      # @param [Hash] track
      def new_login_attempt(track)
        check_and_notify(track[:ip_address]&.id, TYPE_LOGIN_ATTEMPT)
      end
    end
  end
end
