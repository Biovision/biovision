# frozen_string_literal: true

# Helper methods for component handling
module BiovisionComponentsHelper
  # @param [BiovisionComponent] entity
  # @param [String] text
  # @param [Hash] options
  def admin_biovision_component_link(entity, text = nil, options = {})
    text ||= component_name(entity.slug)
    link_to(text, admin_component_path(slug: entity.slug), options)
  end

  # @param [String|BiovisionComponent] slug
  def component_name(slug)
    slug = slug.respond_to?(:slug) ? slug.slug : slug
    t("biovision.components.#{slug}.name", default: slug)
  end
end
