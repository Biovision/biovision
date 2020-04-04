# frozen_string_literal: true

# Model has meta description, keywords and title
module MetaTexts
  extend ActiveSupport::Concern

  included do
    validates_length_of :meta_description, maximum: 500
    validates_length_of :meta_keywords, maximum: 250
    validates_length_of :meta_title, maximum: 250

    def self.meta_text_fields
      %i[meta_description meta_keywords meta_title]
    end
  end
end
