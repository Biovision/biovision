# frozen_string_literal: true

# Managing component list
class Admin::BiovisionComponentsController < AdminController
  include CrudEntities
  include EntityPriority
  include ToggleableEntity

  before_action :set_entity, except: %i[index]
end
