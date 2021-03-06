# frozen_string_literal: true

# Helper methods for displaying versions for SimpleImageUploader
module SimpleImageHelper
  # Tiny (48x48) version of simple image
  #
  # @param [ApplicationRecord|SimpleImageUploader] entity
  # @param [Hash] options
  def simple_image_tiny(entity, options = {})
    return '' if entity.nil?

    image = entity.is_a?(SimpleImageUploader) ? entity : entity.image
    default_image = options.delete(:default_image).to_s

    return default_image if image.blank?

    default = {
      alt: image.alt_text,
      load: 'lazy'
    }
    image_tag(image.tiny_url, default.merge(options))
  end

  # Preview (160x160) version of simple image
  #
  # @param [ApplicationRecord|SimpleImageUploader] entity
  # @param [Hash] options
  def simple_image_preview(entity, options = {})
    return '' if entity.nil?

    image = entity.is_a?(SimpleImageUploader) ? entity : entity.image
    default_image = options.delete(:default_image).to_s

    return default_image if image.blank?

    default = {
      alt: image.alt_text,
      load: 'lazy'
    }
    image_tag(image.preview_url, default.merge(options))
  end

  # Small (320x320) version of simple image
  #
  # @param [ApplicationRecord|SimpleImageUploader] entity
  # @param [Hash] options
  def simple_image_small(entity, options = {})
    return '' if entity.nil?

    image = entity.is_a?(SimpleImageUploader) ? entity : entity.image
    default_image = options.delete(:default_image).to_s

    return default_image if image.blank?

    default = {
      alt: image.alt_text,
      load: 'lazy'
    }
    default[:srcset] = "#{image.medium.url} 2x" if image.raster?

    image_tag(image.small_url, default.merge(options))
  end

  # Medium (640x640) version of simple image
  #
  # @param [ApplicationRecord|SimpleImageUploader] entity
  # @param [Hash] options
  def simple_image_medium(entity, options = {})
    return '' if entity.nil?

    image = entity.is_a?(SimpleImageUploader) ? entity : entity.image
    default_image = options.delete(:default_image).to_s

    return default_image if image.blank?

    default = {
      alt: image.alt_text,
      load: 'lazy'
    }
    default[:srcset] = "#{image.large.url} 2x" if image.raster?

    image_tag(image.medium_url, default.merge(options))
  end

  # Large (1280x1280) version of simple image
  #
  # @param [ApplicationRecord|SimpleImageUploader] entity
  # @param [Hash] options
  def simple_image_large(entity, options = {})
    return '' if entity.nil?

    image = entity.is_a?(SimpleImageUploader) ? entity : entity.image
    default_image = options.delete(:default_image).to_s

    return default_image if image.blank?

    default = {
      alt: image.alt_text,
      load: 'lazy'
    }
    default[:srcset] = "#{image.hd.url} 2x" if image.raster?

    image_tag(image.large_url, default.merge(options))
  end

  # HD (1920x1920) version of simple image
  #
  # @param [ApplicationRecord|SimpleImageUploader] entity
  # @param [Hash] options
  def simple_image_hd(entity, options = {})
    return '' if entity.nil?

    image = entity.is_a?(SimpleImageUploader) ? entity : entity.image
    default_image = options.delete(:default_image).to_s

    return default_image if image.blank?

    default = {
      alt: image.alt_text,
      load: 'lazy'
    }

    image_tag(image.hd_url, default.merge(options))
  end
end
