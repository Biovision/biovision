# frozen_string_literal: true

module Biovision
  module Components
    # Content
    class ContentComponent < BaseComponent
      def self.privilege_names
        %w[content_manager]
      end

      def self.dependent_models
        [DynamicBlock, NavigationGroupPage, NavigationGroup, DynamicPage]
      end

      def use_parameters?
        true
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
