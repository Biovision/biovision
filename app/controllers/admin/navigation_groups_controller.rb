# frozen_string_literal: true

# Administrative part for handling navigation_groups
class Admin::NavigationGroupsController < AdminController
  before_action :set_entity, except: :index

  # get /admin/navigation_groups
  def index
    @collection = NavigationGroup.list_for_administration
  end

  # get /admin/navigation_groups/:id
  def show
  end

  private

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end

  def set_entity
    @entity = NavigationGroup.find_by(id: params[:id])
    handle_http_404('Cannot find navigation_group') if @entity.nil?
  end
end
