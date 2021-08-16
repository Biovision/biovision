# frozen_string_literal: true

# Domain for OEmbed receiver
#
# Attributes:
#   name [String]
#   oembed_receiver_id [OembedReceiver]
class OembedDomain < ApplicationRecord
  include RequiredUniqueName

  NAME_LIMIT = 255

  belongs_to :oembed_receiver

  validates_length_of :name, maximum: NAME_LIMIT

  # @param [String] name
  def self.[](name)
    find_by(name: name.to_s.downcase)
  end

  def receiver_slug
    oembed_receiver&.slug
  end
end
