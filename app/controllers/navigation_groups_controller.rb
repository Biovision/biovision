# frozen_string_literal: true

# Handling navigation_groups
class NavigationGroupsController < AdminController
  include CreateAndModifyEntities

  before_action :set_entity, except: %i[check create new]

  private

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end
end
