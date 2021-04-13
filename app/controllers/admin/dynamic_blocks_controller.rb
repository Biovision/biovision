# frozen_string_literal: true

# Administrative part for handling dynamic_blocks
class Admin::DynamicBlocksController < AdminController
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new]

  private

  def component_class
    Biovision::Components::ContentComponent
  end
end
