# frozen_string_literal: true

# Helpers for Users component
module UsersHelper
  # @param [User] entity
  def user_image_tiny(entity)
    return image_tag('biovision/placeholders/user.svg', alt: '') if entity.nil?

    image_tag(entity.image.tiny.url, alt: '')
  end

  # @param [User] entity
  # @param [Hash] options
  def user_image_profile(entity, options = {})
    if entity&.image.blank? || entity.deleted?
      image_tag('biovision/placeholders/user.svg', alt: '')
    else
      default_options = {
        alt: entity.profile_name,
        srcset: "#{entity.image.big.url} 2x"
      }
      image_tag(entity.image.profile.url, default_options.merge(options))
    end
  end
end
