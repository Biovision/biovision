# frozen_string_literal: true

# Administrative part for handling dynamic_pages
class Admin::DynamicPagesController < AdminController
  include ListAndShowEntities
  include ToggleableEntity

  private

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end
end
