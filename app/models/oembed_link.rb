# frozen_string_literal: true

# Link from oembed tag
#
# Attributes:
#   code [Text], optional
#   created_at [DateTime]
#   updated_at [DateTime]
#   url [String]
class OembedLink < ApplicationRecord
  URL_LIMIT = 255

  validates_presence_of :url
  before_save { self.url = url.to_s[0..(URL_LIMIT - 1)] }

  def self.[](url)
    find_or_initialize_by(url: url)
  end
end
