# frozen_string_literal: true

# Model has meta description, keywords and title
module MetaTexts
  extend ActiveSupport::Concern

  included do
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
  end
end
