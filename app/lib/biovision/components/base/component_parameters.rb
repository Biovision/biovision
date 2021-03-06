# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Getting and setting component parameters
      module ComponentParameters
        def use_parameters?
          false
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
          @component.get(key)
        end

        # Set parameter
        #
        # @param [String] key
        # @param [String] value
        def []=(key, value)
          @component[key] = value unless key.blank?
        end
      end
    end
  end
end
