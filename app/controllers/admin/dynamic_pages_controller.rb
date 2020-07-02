# frozen_string_literal: true

# Administrative part for handling dynamic_pages
class Admin::DynamicPagesController < AdminController
  include ToggleableEntity

  before_action :set_entity, except: :index

  # get /admin/dynamic_pages
  def index
    @collection = DynamicPage.list_for_administration
  end

  # get /admin/dynamic_pages/:id
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
    @entity = DynamicPage.find_by(id: params[:id])
    handle_http_404('Cannot find dynamic_page') if @entity.nil?
  end
end
