# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Getting and setting component parameters
      module ComponentParameters
        def use_parameters?
          false
        end

        def use_files?
          false
        end

        def manage_settings?
          use_parameters? || component.settings.any?
        end

        # Receive parameter value with default
        #
        # Returns value of component's parameter or default value
        # when it's not found
        #
        # @param [String] key
        # @param [String] default
        # @return [String]
        def receive(key, default = '')
          @component.get(key, default)
        end

        # Receive parameter value or nil
        #
        # Returns value of component's parameter of nil when it's not found
        #
        # @param [String] key
        # @return [String]
        def [](key)
          @component.get(key, nil)
        end

        # Set parameter
        #
        # @param [String] key
        # @param [String] value
        def []=(key, value)
          return if key.blank?

          @component.parameters[key.to_s] = value
          @component.save!
        end
      end
    end
  end
end
