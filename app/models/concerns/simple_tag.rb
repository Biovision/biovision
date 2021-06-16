# frozen_string_literal: true

# Adds list of toggleable attributes to model
#
# @author Maxim Khan-Magomedov <maxim.km@gmail.com>
module SimpleTag
  extend ActiveSupport::Concern

  included do

    before_validation :normalize_name
    validates_uniqueness_of :name, case_sensitive: false

    scope :list_for_administration, -> { order(:name) }

    def self.entity_parameters
      %i[name]
    end

    def self.name_limit
      100
    end

    private

    def normalize_name
      self.name = name.to_s[0..name_limit]
    end
  end
end
