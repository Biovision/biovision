# frozen_string_literal: true

# Handling dynamic_blocks
class DynamicBlocksController < AdminController
  before_action :set_entity, only: %i[edit update destroy]

  # post /dynamic_blocks/check
  def check
    @entity = DynamicBlock.instance_for_check(params[:entity_id], entity_parameters)

    render 'shared/forms/check'
  end

  # get /dynamic_blocks/new
  def new
    @entity = DynamicBlock.new
  end

  # post /dynamic_blocks
  def create
    @entity = DynamicBlock.new(entity_parameters)
    if @entity.save
      form_processed_ok(admin_dynamic_block_path(id: @entity.id))
    else
      form_processed_with_error(:new)
    end
  end

  # get /dynamic_blocks/:id/edit
  def edit
  end

  # patch /dynamic_blocks/:id
  def update
    if @entity.update(entity_parameters)
      form_processed_ok(admin_dynamic_block_path(id: @entity.id))
    else
      form_processed_with_error(:edit)
    end
  end

  # delete /dynamic_blocks/:id
  def destroy
    flash[:notice] = t('.success') if @entity.destroy

    redirect_to(admin_dynamic_blocks_path)
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
    @entity = DynamicBlock.find_by(id: params[:id])
    handle_http_404('Cannot find dynamic_block') if @entity.nil?
  end

  def entity_parameters
    params.require(:dynamic_block).permit(DynamicBlock.entity_parameters)
  end
end
