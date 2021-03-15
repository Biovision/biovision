# frozen_string_literal: true

# Model has meta description, keywords and title
module MetaTexts
  extend ActiveSupport::Concern

  included do
    def self.meta_keys
      %w[title keywords description heading]
    end

    # @param [String] key
    # @param [String] default
    def meta(key, default = '')
      message = "meta_#{key}".to_sym
      if respond_to?(message)
        send(message)
      else
        data.dig('meta', key.to_s) || default
      end
    end

    def meta!
      data['meta'].to_h
    end

    # @param [Hash] new_data
    def meta=(new_data)
      data['meta'] = {}

      self.class.meta_keys.each do |key|
        data['meta'][key] = new_data[key]
      end
    end
  end
end
