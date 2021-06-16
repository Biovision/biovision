# frozen_string_literal: true

# Link between simple image and tag
#
# Attributes:
#   uploaded_file_id [UploadedFile]
#   uploaded_file_tag_id [UploadedFileTag]
class UploadedFileTagFile < ApplicationRecord
  belongs_to :uploaded_file
  belongs_to :uploaded_file_tag, counter_cache: :uploaded_files_count

  validates_uniqueness_of :uploaded_file_tag_id, scope: :uploaded_file_id
end
