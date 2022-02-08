# frozen_string_literal: true

# Universal simple image
# 
# Attributes:
#   agent_id [Agent], optional
#   biovision_component_id [BiovisionComponent]
#   caption [string], optional
#   checksum [String], optional
#   created_at [DateTime]
#   data [jsonb]
#   image [SimpleImageUploader]
#   image_alt_text [string]
#   ip_address_id [IpAddress], optional
#   object_count [integer]
#   source_link [string], optional
#   source_name [string], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [uuid]
class SimpleImage < ApplicationRecord
  include Checkable
  include HasOwner
  include HasTrack
  include HasUuid

  META_LIMIT = 255
  ORIGINAL_CHECKSUM = 'original_checksum'

  mount_uploader :image, SimpleImageUploader

  belongs_to :agent, optional: true
  belongs_to :biovision_component
  belongs_to :user, optional: true
  has_many :simple_image_tag_images, dependent: :destroy
  has_many :simple_image_tags, through: :simple_image_tag_images

  before_save :calculate_checksum

  validates_presence_of :image
  validates_length_of :caption, maximum: META_LIMIT
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :source_link, maximum: META_LIMIT
  validates_length_of :source_name, maximum: META_LIMIT

  scope :in_component, ->(v) { where(biovision_component: v) }
  scope :filtered, ->(v) { where('image ilike ? or caption ilike ?', "%#{v}%", "%#{v}%") unless v.blank? }
  scope :list_for_administration, -> { order(:image) }

  # @param [String] input
  def self.[](input)
    case input
    when /\A\h{8}-\h{4}-4\h{3}-[89ab]\h{3}-\h{12}\Z/i
      find_by(uuid: input)
    when /\A[a-f0-9]{64}\z/i
      key = "data->>'#{ORIGINAL_CHECKSUM}'"
      find_by(checksum: input) || find_by("#{key} = ?", input)
    end
  end

  def self.entity_parameters
    %i[caption image image_alt_text source_link source_name]
  end

  def self.json_attributes
    %i[caption image_alt_text source_link source_name]
  end

  def name
    return if image.path.blank?

    File.basename(image.path)
  end

  def file_size
    return 0 if image.path.blank?

    File.size(image.path)
  end

  def image_slug
    "#{uuid[0..2]}/#{uuid[3..5]}/#{uuid}"
  end

  private

  def calculate_checksum
    return if image&.path.blank?

    self.checksum = Digest::SHA256.file(image.path).hexdigest
  end
end
