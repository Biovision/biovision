# frozen_string_literal: true

# Contact method
#
# Attributes:
#   contact_type_id [ContactType]
#   created_at [DateTime]
#   data [jsonb]
#   language_id [Language], optional
#   name [string], optional
#   priority [integer]
#   updated_at [DateTime]
#   uuid [uuid]
#   value [string]
#   visible [boolean]
class ContactMethod < ApplicationRecord
  include Checkable
  include FlatPriority
  include HasLanguage
  include HasUuid
  include Toggleable

  NAME_LIMIT = 50
  VALUE_LIMIT = 255

  toggleable :visible

  belongs_to :language, optional: true
  belongs_to :contact_type

  validates_presence_of :value
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :value, maximum: VALUE_LIMIT

  scope :visible, -> { where(visible: true) }
  scope :list_for_administration, -> { ordered_by_priority }
  scope :list_for_visitors, -> { visible.ordered_by_priority }

  # @param [String] slug
  def self.[](slug)
    ContactType[slug]&.contact_methods&.list_for_visitors
  end

  def self.entity_parameters(*)
    %i[contact_type_id language_id name priority value visible]
  end
end
