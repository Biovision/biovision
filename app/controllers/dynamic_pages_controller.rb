# frozen_string_literal: true

# Handling dynamic_pages
class DynamicPagesController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # post /dynamic_pages/check
  def check
    @entity = DynamicPage.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /dynamic_pages/new
  def new
    @entity = DynamicPage.new
  end

  # post /dynamic_pages
  def create
    @entity = DynamicPage.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_dynamic_page_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /dynamic_pages/:id/edit
  def edit
  end

  # patch /dynamic_pages/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_dynamic_page_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /dynamic_pages/:id
  def destroy
    flash[:notice] = t('.success') if @entity.destroy

    redirect_to(admin_dynamic_pages_path)
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
    @entity = DynamicPage.find_by(id: params[:id])
    handle_http_404('Cannot find dynamic_page') if @entity.nil?
  end

  def entity_parameters
    params.require(:dynamic_page).permit(DynamicPage.entity_parameters)
  end
end
