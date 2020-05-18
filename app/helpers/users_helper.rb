# frozen_string_literal: true

# Helpers for Users component
module UsersHelper
  # @param [User] entity
  def user_image_tiny(entity)
    return image_tag('biovision/placeholders/user.svg', alt: '') if entity.nil?

    image_tag(entity.image.tiny.url, alt: '')
  end
end
