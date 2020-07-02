# frozen_string_literal: true

# Handling navigation_groups
class NavigationGroupsController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # post /navigation_groups/check
  def check
    @entity = NavigationGroup.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /navigation_groups/new
  def new
    @entity = NavigationGroup.new
  end

  # post /navigation_groups
  def create
    @entity = NavigationGroup.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_navigation_group_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /navigation_groups/:id/edit
  def edit
  end

  # patch /navigation_groups/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_navigation_group_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /navigation_groups/:id
  def destroy
    flash[:notice] = t('navigation_groups.destroy.success') if @entity.destroy

    redirect_to(admin_navigation_groups_path)
  end

  protected

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

  def entity_parameters
    params.require(:navigation_group).permit(NavigationGroup.entity_parameters)
  end
end
