# frozen_string_literal: true

# Administrative part for handling navigation_groups
class Admin::NavigationGroupsController < AdminController
  include CrudEntities

  before_action :set_entity, except: %i[check create index new]

  private

  def component_class
    Biovision::Components::ContentComponent
  end
end
