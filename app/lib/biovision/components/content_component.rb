# frozen_string_literal: true

module Biovision
  module Components
    # Content
    class ContentComponent < BaseComponent
      def self.privilege_names
        %w[content_manager]
      end

      def use_parameters?
        true
      end
    end
  end
end