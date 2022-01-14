# frozen_string_literal: true

# Uploaded file
#
# Attributes:
#   attachment [SimpleFileUploader]
#   agent_id [Agent], optional
#   biovision_component_id [BiovisionComponent]
#   checksum [String]
#   created_at [DateTime]
#   data [jsonb]
#   description [String], optional
#   ip_address_id [IpAddress], optional
#   object_count [Integer]
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [uuid]
class UploadedFile < ApplicationRecord
  include Checkable
  include HasOwner
  include HasTrack
  include HasUuid

  META_LIMIT = 255

  mount_uploader :attachment, SimpleFileUploader

  belongs_to :agent, optional: true
  belongs_to :biovision_component
  belongs_to :user, optional: true
  has_many :uploaded_file_tag_files, dependent: :destroy
  has_many :uploaded_file_tags, through: :uploaded_file_tag_files

  before_save :calculate_checksum

  validates_presence_of :attachment
  validates_length_of :description, maximum: META_LIMIT

  scope :in_component, ->(v) { where(biovision_component: v) }
  scope :filtered, ->(v) { where('description ilike ? or attachment ilike ?', "%#{v}%", "%#{v}%") unless v.blank? }
  scope :list_for_administration, -> { order('attachment asc') }

  def self.entity_parameters
    %i[attachment description]
  end

  # @param [String] input
  def self.[](input)
    case input
    when /\A\h{8}-\h{4}-4\h{3}-[89ab]\h{3}-\h{12}\Z/i
      find_by(uuid: input)
    when /\A[a-f0-9]{64}\z/i
      find_by(checksum: input)
    end
  end

  def name
    File.basename(attachment.path)
  end

  def file_size
    File.size(attachment.path)
  end

  private

  def calculate_checksum
    return if attachment&.path.blank?

    self.checksum = Digest::SHA256.file(attachment.path).hexdigest
  end
end
