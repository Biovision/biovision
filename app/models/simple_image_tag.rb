# frozen_string_literal: true

# Tag for simple image
# 
# Attributes:
#   created_at [DateTime]
#   name [string]
#   simple_images_count [integer]
#   updated_at [DateTime]
class SimpleImageTag < ApplicationRecord
  include Checkable
  include SimpleTag

  has_many :simple_image_tag_images, dependent: :delete_all
end
