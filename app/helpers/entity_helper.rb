# frozen_string_literal: true

# Helpers for displaying common entity-related blocks
module EntityHelper
  # @param [ApplicationRecord] entity
  def linked_entity_block(entity)
    return '' if entity.blank?

    render partial: 'shared/entity/linked_entity', locals: { entity: entity }
  end

  # @param [ApplicationRecord] entity
  # @param [String|Symbol] types
  def entity_partial_block(entity, *types)
    permitted = %i[
      priority uuid slug timestamps language simple_image meta_texts track
    ]

    buffer = ''
    types.select { |i| permitted.include?(i.to_sym)}.each do |type|
      buffer += render(partial: "shared/entity/#{type}", locals: { entity: entity })
    end

    raw buffer
  end

  def entity_form_block(f, *types)
    permitted = %i[priority entity_flags simple_image]

    buffer = ''
    types.select { |i| permitted.include?(i.to_sym)}.each do |type|
      buffer += render partial: "shared/forms/#{type}", locals: { f: f }
    end

    raw buffer
  end
end
