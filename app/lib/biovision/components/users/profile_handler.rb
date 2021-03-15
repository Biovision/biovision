# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Handling user profiles
      class ProfileHandler
        GENDERS = { 0 => 'female', 1 => 'male', 2 => 'other' }.freeze

        attr_accessor :user

        # @param [Biovision::Components::UsersComponent] component
        def initialize(component)
          @component = component
        end

        # List of attributes that can be used in user profile
        #
        # Change this method in decorators for other values
        def self.allowed_parameters
          %w[gender name patronymic surname about]
        end

        # List of parameters to be used in controllers for create/update
        def self.permitted_for_request
          allowed_parameters.map do |key|
            key.respond_to?(:to_h) ? [[key.shift, key]].to_h : key
          end
        end

        # Normalize profile parameters for storage
        #
        # Makes consistent format of profile hash.
        #
        # @param [Hash] input
        def self.clean_parameters(input)
          return {} unless input.respond_to?(:key?)

          output = normalized_parameters(input)
          (allowed_parameters - output.keys).each do |parameter|
            if parameter.respond_to?(:shift)
              key = parameter.shift
              output[key] = array_value(input[key].to_h, parameter)
            else
              output[parameter] = scalar_value(input, parameter)
            end
          end
          output
        end

        # @param [Hash] input
        # @param [String] key
        def self.scalar_value(input, key)
          input.key?(key) ? input[key].to_s : nil
        end

        # @param [Hash] input
        # @param [Array] keys
        def self.array_value(input, keys)
          keys.each.map { |key| [key, scalar_value(input, key)] }.to_h
        end

        # @param [Integer|nil] gender_id
        def self.gender(gender_id)
          prefix = 'activerecord.attributes.user_profile.genders'
          gender_key = gender_id.blank? ? '' : gender_id.to_i
          postfix = GENDERS[gender_key] || 'not_set'
          I18n.t("#{prefix}.#{postfix}")
        end

        def self.genders_for_select
          default_key = 'activerecord.attributes.user_profile.genders.not_set'
          genders = [[I18n.t(default_key), '']]
          genders + GENDERS.keys.map { |k| [gender(k), k] }
        end

        # Format parameters that have more restrictions than just "string" type
        #
        # Change this method in decorator to add other fields with type
        # enumerable, integer, etc.
        #
        # @param [Hash] input
        def self.normalized_parameters(input)
          { gender: clean_gender(input['gender']) }
        end

        # Restrict gender to only available values
        #
        # Defined gender is stored as integer.
        #
        # @param [Integer] input
        def self.clean_gender(input)
          gender_key = input.blank? ? nil : input.to_i
          GENDERS.key?(gender_key) ? gender_key : nil
        end

        # @param [Hash] profile_data
        def profile=(profile_data)
          user.profile = self.class.clean_parameters(profile_data).to_h
        end

        # @param [Hash] user_data
        # @param [Hash] profile_data
        def create(user_data, profile_data)
          self.user = User.new(user_data)
          self.profile = profile_data
          Biovision::Components::UsersComponent.created_user(user) if user.save
          user
        end

        # @param [Hash] user_data
        # @param [Hash] profile_data
        def update(user_data, profile_data)
          return if user.nil?

          self.profile = profile_data
          user.update(user_data)
        end
      end
    end
  end
end
