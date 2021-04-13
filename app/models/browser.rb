# frozen_string_literal: true

# Browser
#
# Attributes:
#   agents_count [integer]
#   banned [boolean]
#   created_at [DateTime]
#   mobile [boolean]
#   name [string]
#   updated_at [DateTime]
#   version [string]
class Browser < ApplicationRecord
  include Checkable
  include Toggleable

  NAME_LIMIT = 50
  VERSION_LIMIT = 10

  toggleable :banned

  has_many :agents, dependent: :nullify

  validates_presence_of :name, :version
  validates_uniqueness_of :version, scope: :name
  validates_length_of :name, maximum: NAME_LIMIT
  validates_length_of :version, maximum: VERSION_LIMIT

  scope :list_for_administration, -> { order('name asc, version asc') }

  def self.entity_parameters(*)
    %i[banned mobile name version]
  end
end
