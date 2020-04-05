# frozen_string_literal: true

# Model references to simple image
module HasSimpleImage
  extend ActiveSupport::Concern

  included do
    belongs_to :simple_image, optional: true, counter_cache: :object_count
  end

  def image
    simple_image&.image
  end

  def image_alt_text
    simple_image&.image_alt_text
  end
end
