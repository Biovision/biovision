# frozen_string_literal: true

module Biovision
  module Components
    module Base
      # Handling simple images
      module FileHandling
        def use_files?
          false
        end

        # @param [Hash] parameters
        def upload_file(parameters)
          return if parameters[:attachment].blank?

          checksum = Digest::SHA256.file(parameters[:attachment].path).hexdigest
          UploadedFile[checksum] || create_file(parameters)
        end

        private

        # @param [Hash] parameters
        def create_file(parameters)
          component.uploaded_files.create(parameters)
        end
      end
    end
  end
end
