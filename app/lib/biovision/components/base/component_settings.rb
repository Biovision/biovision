# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Normalizing component settings
      module ComponentSettings
        def settings_flags
          []
        end

        def settings_numbers
          []
        end

        def settings_strings
          []
        end

        # @param [Hash] data
        def normalize_settings(data)
          result = {}
          settings_flags.each { |f| result[f] = data[f].to_i == 1 }
          settings_numbers.each { |n| result[n] = data[n].to_i }
          settings_strings.each { |s| result[s] = data[s].to_s }

          result
        end
      end
    end
  end
end
