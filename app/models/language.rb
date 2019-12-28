# frozen_string_literal: true

# Language
#
# Attributes:
#   active [Boolean]
#   code [String]
#   created_at [DateTime]
#   priority [Integer]
#   slug [String]
#   updated_at [DateTime]
class Language < ApplicationRecord
  include FlatPriority
end
