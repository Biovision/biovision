# frozen_string_literal: true

# Metric for component
# 
# Attributes:
#   biovision_component_id [BiovisionComponent]
#   created_at [DateTime]
#   default_period [integer]
#   incremental [boolean]
#   previous_value [integer]
#   show_on_dashboard [boolean]
#   start_with_zero [boolean]
#   name [string]
#   updated_at [DateTime]
#   value [integer]
class Metric < ApplicationRecord
  include RequiredUniqueName
  include Toggleable

  NAME_LIMIT = 255
  PERIOD_RANGE = (1..366).freeze

  belongs_to :biovision_component
  has_many :metric_values, dependent: :delete_all

  validates_length_of :name, maximum: NAME_LIMIT
end
