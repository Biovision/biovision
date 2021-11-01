# frozen_string_literal: true

module Biovision
  module Stories
    # Base component story
    class ComponentStory
      attr_accessor :component_handler, :entity

      # @param [Biovision::Components::BaseComponent] handler
      # @param [ApplicationRecord|nil] entity
      def initialize(handler, entity = nil)
        self.component_handler = handler
        self.entity = entity
      end

      # @param [Hash] parameters
      def perform(parameters)
        # implement in children and return hash
        parameters
      end
    end
  end
end
