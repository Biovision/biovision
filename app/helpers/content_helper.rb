# frozen_string_literal: true

# Helper methods for Content component
module ContentHelper
  # @param [NavigationGroup] entity
  # @param [String] text
  # @param [Hash] options
  def admin_navigation_group_link(entity, text = entity.name, options = {})
    link_to(text, admin_navigation_group_path(id: entity.id), options)
  end

  # @param [DynamicBlock] entity
  # @param [String] text
  # @param [Hash] options
  def admin_dynamic_block_link(entity, text = entity.slug, options = {})
    link_to(text, admin_dynamic_block_path(id: entity.id), options)
  end

  # @param [DynamicPage] entity
  # @param [String] text
  # @param [Hash] options
  def admin_dynamic_page_link(entity, text = entity.long_slug, options = {})
    link_to(text, admin_dynamic_block_path(id: entity.id), options)
  end
end
