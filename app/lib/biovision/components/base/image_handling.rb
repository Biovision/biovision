# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Handling simple images
      module ImageHandling
        def use_images?
          false
        end

        # @param [Hash] parameters
        def upload_image(parameters)
          return if parameters[:image].blank?

          checksum = Digest::SHA256.file(parameters[:image].path).hexdigest
          SimpleImage[checksum] || create_image(parameters, checksum)
        end

        private

        # @param [Hash] parameters
        # @param [String] checksum
        def create_image(parameters, checksum)
          image = component.simple_images.new(parameters)
          image.data[SimpleImage::ORIGINAL_CHECKSUM] = checksum
          image.save
          image
        end
      end
    end
  end
end
