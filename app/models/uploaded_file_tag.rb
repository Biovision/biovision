# frozen_string_literal: true

# Tag for uploaded file
#
# Attributes:
#   created_at [DateTime]
#   name [string]
#   uploaded_files_count [integer]
#   updated_at [DateTime]
class UploadedFileTag < ApplicationRecord
  include Checkable
  include SimpleTag

  has_many :uploaded_file_tag_files, dependent: :delete_all
end
