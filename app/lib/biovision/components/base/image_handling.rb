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
          SimpleImage[checksum] || create_image(parameters)
        end

        private

        # @param [Hash] parameters
        def create_image(parameters)
          component.simple_images.create(parameters)
        end
      end
    end
  end
end
