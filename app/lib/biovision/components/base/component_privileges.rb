# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Handling component privileges
      module ComponentPrivileges
        # @param [String|Array] privileges
        def allow?(*privileges)
          return false if user.nil?
          return true if administrator? || (component.nil? && privileges.blank?)
          return false if @user_link.nil?

          result = privileges.blank?
          privileges.flatten.each { |slug| result |= privilege?(slug) }
          result
        end

        # @param [String] privilege_name
        def privilege?(privilege_name)
          privilege_handler.privilege?(privilege_name)
        end
      end
    end
  end
end
