# frozen_string_literal: true

# Language
#
# Attributes:
#   active [Boolean]
#   code [String]
#   created_at [DateTime]
#   object_count [Integer]
#   priority [Integer]
#   slug [String]
#   updated_at [DateTime]
class Language < ApplicationRecord
  include FlatPriority
  include RequiredUniqueSlug

  CODE_PATTERN = /\A[a-z]{2,3}(-[A-z][a-z]{3})?(-[A-Z]{2})?\z/.freeze
  SLUG_PATTERN = /\A[a-z][-a-z0-9]{,18}[a-z0-9]\z/.freeze

  validates_presence_of :code
  validates_uniqueness_of :code
  validates_format_of :code, with: CODE_PATTERN
  validates_format_of :slug, with: SLUG_PATTERN

  scope :active, -> { where(active: true) }

  # @param [String|Symbol] code
  def self.[](code)
    find_by(code: code)
  end

  def name
    I18n.t("languages.#{slug}", default: slug)
  end
end
