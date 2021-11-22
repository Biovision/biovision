# frozen_string_literal: true

module Biovision
  module Stories
    # Base component story
    class ComponentStory
      attr_accessor :component_handler, :entity

      # @param [Biovision::Components::BaseComponent] handler
      # @param [ApplicationRecord|String|nil] entity
      def initialize(handler, entity = nil)
        self.component_handler = handler
        return if entity.blank?

        if entity.is_a?(ApplicationRecord)
          self.entity = entity
        else
          self.entity_id = entity.to_s
        end
      end

      # Get associated model class
      #
      # This method should be implemented in children if story name
      # does not match model name.
      # The result is used in #entity_id=
      def model_class
        model_name = to_s.demodulize.to_s.underscore.gsub('_story', '')
        model_name.classify.safe_constantize
      end

      # @param [Hash] parameters
      def perform(parameters)
        @parameters = parameters
        # implement in children and return hash
        { result: 'Nothing was processed.' }
      end

      # Set entity identified by value
      #
      # This method can be implemented in child classes
      #
      # @param [String] value
      def entity_id=(value)
        return if model_class.nil?

        if model_class.respond_to?(:[])
          self.entity = model_class[value]
        elsif model_class.respond_to?(:find_by)
          self.entity = model_class.find_by(id: value)
        end
      end
    end
  end
end
