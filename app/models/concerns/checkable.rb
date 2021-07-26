# frozen_string_literal: true

# Adds method for validating model in controllers
#
# @author Maxim Khan-Magomedov <maxim.km@gmail.com>
module Checkable
  extend ActiveSupport::Concern

  included do
    # @param id
    # @param [Hash] parameters
    def self.instance_for_check(id, parameters)
      if id.blank?
        entity = new(parameters)
      else
        key = column_names.include?('uuid') && id.include?('-') ? :uuid : :id
        entity = find_by(key => id)
        entity.assign_attributes(parameters)
      end
      entity
    end
  end
end
