# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Handling user profiles
      class ProfileHandler
        GENDERS = { 0 => 'female', 1 => 'male', 2 => 'other' }.freeze

        attr_accessor :user

        # @param [Integer|nil] gender_id
        def self.gender(gender_id)
          prefix = 'activerecord.attributes.user_profile.genders'
          gender_key = gender_id.blank? ? '' : gender_id.to_i
          postfix = GENDERS[gender_key] || 'not_set'
          I18n.t("#{prefix}.#{postfix}")
        end
      end
    end
  end
end
