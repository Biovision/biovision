# frozen_string_literal: true

# Administrative part for handling dynamic_pages
class Admin::DynamicPagesController < AdminController
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new search]

  private

  def component_class
    Biovision::Components::ContentComponent
  end
end
