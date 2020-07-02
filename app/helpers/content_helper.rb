# frozen_string_literal: true

# Helper methods for Content component
module ContentHelper
  # @param [NavigationGroup] entity
  # @param [String] text
  # @param [Hash] options
  def admin_navigation_group_link(entity, text = entity.name, options = {})
    link_to(text, admin_navigation_group_path(id: entity.id), options)
  end
end
