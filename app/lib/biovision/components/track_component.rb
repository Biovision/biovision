# frozen_string_literal: true

module Biovision
  module Components
    # Component for tracking UA and IP
    class TrackComponent < BaseComponent
      def self.dependent_models
        [Browser, Agent, IpAddress]
      end
    end
  end
end
