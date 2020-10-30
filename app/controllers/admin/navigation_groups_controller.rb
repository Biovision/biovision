# frozen_string_literal: true

# Administrative part for handling navigation_groups
class Admin::NavigationGroupsController < AdminController
  include ListAndShowEntities

  private

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end
end
