# frozen_string_literal: true

# Model references to uploaded file
module HasUploadedFile
  extend ActiveSupport::Concern

  included do
    belongs_to :uploaded_file, optional: true, counter_cache: :object_count

    scope :included_file, -> { includes(:uploaded_file) }
  end

  def attachment_name
    uploaded_file&.name
  end

  def attachment_size
    uploaded_file&.file_size
  end

  def attachment_url
    return if uploaded_file&.attachment.blank?

    uploaded_file.attachment.url
  end
end
