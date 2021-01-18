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

        private

        def let_user_in?
          if user.nil? || user.banned?
            register_failure && false
          else
            too_many_attempts? ? (log_attempt && false) : try_password
          end
        end

        def too_many_attempts?
          timeout = settings[self.class::SETTING_BOUNCE_TIMEOUT].to_i.abs
          limit = settings[self.class::SETTING_BOUNCE_COUNT].to_i
          LoginAttempt.owned_by(user).since(timeout.minutes.ago).count > limit
        end

        def log_attempt
          data = { password: @password }
          LoginAttempt.owned_by(user).create(data.merge(@track))
        end

        def try_password
          user.authenticate(@password) || (count_attempt && false)
        end

        def count_attempt
          register_failure
          log_attempt
          return unless too_many_attempts?

          notifier = Biovision::Notifiers::UsersNotifier.new(user)
          notifier.new_login_attempt(@track)
        end

        def register_failure
          metric = Biovision::Components::UsersComponent::METRIC_AUTH_FAILURE
          register_metric(metric)
        end
      end
    end
  end
end
