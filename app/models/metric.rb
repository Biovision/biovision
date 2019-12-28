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
  belongs_to :biovision_component
end
