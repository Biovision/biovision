# frozen_string_literal: true

# Model references to language
module HasLanguage
  extend ActiveSupport::Concern

  included do
    belongs_to :language, optional: true, counter_cache: :object_count
  end
end
