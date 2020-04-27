# frozen_string_literal: true

module Biovision
  module Components
    module Users
      # Handling user codes for different components
      class CodeHandler
        attr_accessor :code

        # @param [Biovision::Components::BaseComponent] component
        # @param [Code] code
        def initialize(component, code = nil)
          @component = component
          self.code = code
        end

        def valid?
          true
        end
      end
    end
  end
end
