# frozen_string_literal: true

# Uploader for universal simple images
class SimpleImageUploader < CarrierWave::Uploader::Base
  include Uploaders::PathSlug
  include CarrierWave::ImageOptim
  include CarrierWave::MiniMagick

  storage :file

  def default_url(*)
    ActionController::Base.helpers.asset_path('biovision/placeholders/1x1.svg')
  end

  process :auto_orient, if: :auto_orient?
  process optimize: [{ jpegoptim: true, optipng: true, svgo: true }], if: :optimize_images?

  def auto_orient
    return unless raster?

    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  version :hd, if: :raster_image? do
    resize_to_fit(1920, 1920)
  end

  version :large, from_version: :hd, if: :raster_image? do
    resize_to_fit(1280, 1280)
  end

  version :medium, from_version: :large, if: :raster_image? do
    resize_to_fit(640, 640)
  end

  version :small, from_version: :medium, if: :raster_image? do
    resize_to_fit(320, 320)
  end

  version :preview, from_version: :small, if: :raster_image? do
    resize_to_fit(160, 160)
  end

  version :tiny, from_version: :preview, if: :raster_image? do
    resize_to_fit(48, 48)
  end

  def extension_allowlist
    [/jpe?g/, 'png', /svgz?/]
  end

  # Text for image alt attribute
  #
  # @param [String] default
  # @return [String]
  def alt_text(default = '')
    method_name = "#{mounted_as}_alt_text".to_sym
    if model.respond_to?(method_name)
      model.send(method_name)
    else
      default
    end
  end

  # @param [SanitizedFile]
  def raster_image?(new_file)
    !new_file.extension.match?(/svgz?\z/i)
  end

  def optimize_images?(*)
    return false unless Rails.application.config.respond_to? :optimize_images

    Rails.application.config.optimize_images
  end

  def auto_orient?(*)
    return false unless Rails.application.config.respond_to? :auto_orient

    Rails.application.config.auto_orient
  end

  def raster?
    !File.extname(path).match?(/\.svgz?\z/i)
  end

  def tiny_url
    raster? ? tiny.url : url
  end

  def preview_url
    raster? ? preview.url : url
  end

  def small_url
    raster? ? small.url : url
  end

  def medium_url
    raster? ? medium.url : url
  end

  def large_url
    raster? ? large.url : url
  end

  def hd_url
    raster? ? hd.url : url
  end
end
