# frozen_string_literal: true

# Metric value
#
# Attributes:
#   metric_id [Metric]
#   quantity [Integer]
#   value [Integer]
class MetricValue < ApplicationRecord
  belongs_to :metric
end
