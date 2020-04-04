# frozen_string_literal: true

module HasTrack
  extend ActiveSupport::Concern

  included do
    belongs_to :agent, optional: true, counter_cache: :object_count
    belongs_to :ip_address, optional: true, counter_cache: :object_count
  end
end
