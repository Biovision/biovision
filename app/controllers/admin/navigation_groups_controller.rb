# frozen_string_literal: true

# Administrative part for handling navigation_groups
class Admin::NavigationGroupsController < AdminController
  include CrudEntities

  before_action :set_entity, except: %i[check create index new]

  # put /admin/navigation_groups/:id/dynamic_pages/:page_id
  def add_page
    @entity.add_dynamic_page(DynamicPage.find_by(id: params[:page_id]))

    head :no_content
  end

  # delete /admin/navigation_groups/:id/dynamic_pages/:page_id
  def remove_page
    @entity.remove_dynamic_page(DynamicPage.find_by(id: params[:page_id]))

    head :no_content
  end

  # post /admin/navigation_groups/:id/dynamic_pages/:page_id/priority
  def page_priority
    link = @entity.navigation_group_pages.find_by(id: params[:page_id])

    if link.nil?
      handle_http_404
    else
      render json: { data: link.change_priority(params[:delta].to_s.to_i) }
    end
  end

  private

  def component_class
    Biovision::Components::ContentComponent
  end

  def action_to_role_map
    super.merge(
      %w[add_page page_priority remove_page] => 'navigation_groups.edit',
    )
  end
end
