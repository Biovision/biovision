# frozen_string_literal: true

# Dynamic page
#
# Attributes:
#   body [text]
#   created_at [DateTime]
#   data [jsonb]
#   language_id [Language], optional
#   name [string]
#   simple_image_id [SimpleImage], optional
#   slug [string]
#   updated_at [DateTime]
#   url [string], optional
#   uuid [uuid]
#   visible [boolean]
class DynamicPage < ApplicationRecord
  include Checkable
  include HasLanguage
  include HasSimpleImage
  include HasUuid
  include Toggleable

  NAME_LIMIT = 100
  SLUG_LIMIT = 100
  URL_LIMIT = 100

  toggleable :visible

  has_many :navigation_group_pages, dependent: :destroy

  validates_presence_of :slug
  validates_uniqueness_of :slug, scope: :language_id
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :slug, maximum: SLUG_LIMIT
  validates_length_of :url, maximum: URL_LIMIT

  scope :list_for_administration, -> { included_image.order('slug asc, language_id asc nulls first') }

  def self.entity_parameters
    %i[body language_id name simple_image_id slug url visible]
  end

  def long_slug
    language.nil? ? slug : "#{slug} (#{language.code})"
  end

  def text_for_link
    long_slug
  end
end
