# frozen_string_literal: true

# Uploader for user images
class UserImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::BombShelter

  storage :file

  def max_pixel_dimensions
    [4000, 4000]
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    uuid = model&.uuid.to_s
    slug = "#{uuid[0..2]}/#{uuid[3..5]}/#{uuid[6..7]}/#{uuid}"

    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{slug}"
  end

  def default_url(*)
    ActionController::Base.helpers.asset_path('biovision/placeholders/1x1.svg')
  end

  process :auto_orient

  def auto_orient
    manipulate! do |image|
      image.tap(&:auto_orient)
    end
  end

  version :hd do
    resize_to_fit(1280, 1280)
  end

  version :large, from_version: :hd do
    resize_to_fit(640, 640)
  end

  version :profile, from_version: :large do
    resize_to_fit(320, 320)
  end

  version :preview, from_version: :profile do
    resize_to_fit(160, 160)
  end

  version :tiny, from_version: :preview do
    resize_to_fit(48, 48)
  end

  def extension_whitelist
    %w[jpg jpeg png]
  end
end
