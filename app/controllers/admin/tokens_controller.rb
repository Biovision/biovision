# frozen_string_literal: true

# Handling user tokens
class Admin::TokensController < AdminController
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new search]

  private

  def component_class
    Biovision::Components::UsersComponent
  end
end
