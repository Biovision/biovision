# frozen_string_literal: true

# Model references to simple image
module HasSimpleImage
  extend ActiveSupport::Concern

  included do
    belongs_to :simple_image, optional: true, counter_cache: :object_count

    scope :included_image, -> { includes(:simple_image) }

    def image_metadata
      {
        url: simple_image&.image&.url,
        alt: simple_image&.image_alt_text
      }
    end
  end

  def image
    simple_image&.image
  end

  def image_alt_text
    simple_image&.image_alt_text
  end
end
