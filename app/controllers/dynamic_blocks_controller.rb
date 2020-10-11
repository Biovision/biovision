# frozen_string_literal: true

# Handling dynamic_blocks
class DynamicBlocksController < AdminController
  include CreateAndModifyEntities

  before_action :set_entity, only: %i[edit update destroy]

  protected

  def component_class
    Biovision::Components::ContentComponent
  end

  def restrict_access
    error = 'Managing content is not allowed'
    handle_http_401(error) unless component_handler.allow?('content_manager')
  end
end
