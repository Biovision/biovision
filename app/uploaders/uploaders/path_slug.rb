# frozen_string_literal: true

module Uploaders
  # Using UUID in file path when available
  module PathSlug
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{path_slug}"
    end

    private

    def path_slug
      if model.respond_to?(:uuid)
        uuid = model.uuid.to_s
        "#{uuid[0..2]}/#{uuid[3..5]}/#{uuid[6..7]}/#{uuid}"
      else
        id = model&.id.to_i
        "#{id / 1000}/#{id}"
      end
    end
  end
end
