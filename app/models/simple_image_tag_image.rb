# frozen_string_literal: true

# Link between simple image and tag
# 
# Attributes:
#   simple_image [references]
#   simple_image_tag [references]
class SimpleImageTagImage < ApplicationRecord
  belongs_to :simple_image
  belongs_to :simple_image_tag
end
