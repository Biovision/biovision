# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Authentication part of users component
      module Authentication
        def authenticate(password, track)
          @password = password
          @track = track
          let_user_in?
        end

        protected

        def let_user_in?
          return false if user.nil? || user.banned?

          too_many_attempts? ? (log_attempt && false) : try_password
        end

        def too_many_attempts?
          timeout = settings['bounce_timeout'].to_i.abs.minutes.ago
          limit = settings['bounce_limit'].to_i
          LoginAttempt.owned_by(user).since(timeout).count > limit
        end

        def log_attempt
          data = { password: @password }
          LoginAttempt.owned_by(user).create(data.merge(@track))
        end

        def try_password
          user.authenticate(@password) || (count_attempt && false)
        end

        def count_attempt
          log_attempt
          return unless too_many_attempts?

          notifier = Biovision::Notifiers::UsersNotifier.new(user)
          notifier.new_login_attempt(@track)
        end
      end
    end
  end
end
