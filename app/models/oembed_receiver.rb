# frozen_string_literal: true

# Receiver for OEmbed links
#
# Attributes:
#   slug [String]
class OembedReceiver < ApplicationRecord
  include RequiredUniqueSlug

  SLUG_PATTERN = /\A[a-z]+(_?[a-z]+){2,49}\z/

  has_many :oembed_domains, dependent: :delete_all

  validates_format_of :slug, with: SLUG_PATTERN
end
