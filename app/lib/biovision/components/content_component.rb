# frozen_string_literal: true

module Biovision
  module Components
    # Content
    class ContentComponent < BaseComponent
      def self.dependent_models
        [DynamicPage, NavigationGroup, NavigationGroupPage, DynamicBlock]
      end

      def use_parameters?
        true
      end

      def use_images?
        true
      end

      def administrative_parts
        %w[navigation_groups dynamic_blocks dynamic_pages]
      end

      # @param [ApplicationRecord] entity
      # @deprecated use #permit?
      def editable?(entity)
        return false if entity.nil?

        permit?('edit', entity)
      end
    end
  end
end
