# frozen_string_literal: true

# Helpers for displaying common entity-related blocks
module EntityHelper
  # @param [Enumerable] collection
  # @param [Symbol|String|nil] scope
  # @param [Biovision::Components::BaseComponent|nil] handler
  # @param [TrueClass|FalseClass] with_priority
  def entity_list(collection, scope: nil, handler: component_handler, with_priority: false)
    scope = controller.class.module_parent_name.to_s.downcase if scope.nil?
    suffix = with_priority ? '_with_priority' : ''

    render(
      partial: "shared/entity/list#{suffix}",
      locals: { collection: collection, handler: handler, scope: scope.to_sym }
    )
  end

  # @param [ApplicationRecord] entity
  # @param [Symbol|String|nil] scope
  def entity_toggle(entity, scope: nil)
    scope = controller.class.module_parent_name.to_s.downcase if scope.nil?

    render(
      partial: 'shared/entity/toggle',
      locals: { entity: entity, scope: scope.to_sym }
    )
  end

  # @param [ApplicationRecord] entity
  # @param [Symbol|String|nil] scope
  def entity_priority_icons(entity, scope: nil)
    scope = controller.class.module_parent_name.to_s.downcase if scope.nil?

    render(
      partial: 'shared/entity/priority_icons',
      locals: { entity: entity, scope: scope.to_sym }
    )
  end

  # @param [ApplicationRecord] entity
  # @param [String] text
  def linked_entity_block(entity, text: nil)
    return '' if entity.blank?

    render(
      partial: 'shared/entity/linked_entity',
      locals: { entity: entity, text: text }
    )
  end

  # @param [ApplicationRecord] entity
  # @param [String|Symbol] types
  def entity_partial_block(entity, *types)
    permitted = %i[
      priority uuid slug timestamps language simple_image meta_texts track
      uploaded_file
    ]

    buffer = ''
    types.select { |i| permitted.include?(i.to_sym)}.each do |type|
      buffer += render(partial: "shared/entity/#{type}", locals: { entity: entity })
    end

    raw buffer
  end

  def entity_form_block(f, *types)
    permitted = %i[priority entity_flags simple_image uploaded_file]

    buffer = ''
    types.select { |i| permitted.include?(i.to_sym)}.each do |type|
      buffer += render partial: "shared/forms/#{type}", locals: { f: f }
    end

    raw buffer
  end

  # @param [ApplicationRecord] entity
  def uploaded_file_link(entity)
    file = entity.uploaded_file

    return '' if file.blank? || file.attachment.blank?

    link_to(file.name, file.attachment.url)
  end
end
