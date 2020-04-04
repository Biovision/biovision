# frozen_string_literal: true

# Universal simple image
# 
# Attributes:
#   agent_id [Agent], optional
#   biovision_component_id [BiovisionComponent]
#   caption [string], optional
#   created_at [DateTime]
#   image [SimpleImageUploader]
#   image_alt_text [string]
#   ip_address_id [IpAddress], optional
#   object_count [integer]
#   source_link [string], optional
#   source_name [string], optional
#   updated_at [DateTime]
#   user_id [User], optional
#   uuid [uuid]
#   data [jsonb]
class SimpleImage < ApplicationRecord
  include Checkable
  include HasOwner
  include HasTrack
  include HasUuid

  CAPTION_LIMIT = 255
  LINK_LIMIT = 255
  NAME_LIMIT = 255
  META_LIMIT = 255

  belongs_to :biovision_component
  belongs_to :user, optional: true

  validates_presence_of :image
  validates_length_of :caption, maximum: CAPTION_LIMIT
  validates_length_of :image_alt_text, maximum: META_LIMIT
  validates_length_of :source_link, maximum: LINK_LIMIT
  validates_length_of :source_name, maximum: NAME_LIMIT

  def self.entity_parameters
    %i[caption image image_alt_text source_link source_name]
  end

  def name
    caption.blank? ? File.basename(image.path) : caption
  end
end
