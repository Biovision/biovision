# frozen_string_literal: true

# Administrative part for handling dynamic_pages
class Admin::UsersController < AdminController
  include Authentication
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new]

  # post /admin/users
  def create
    @entity = component_handler.create_user(entity_parameters, profile_parameters)
    if @entity.persisted?
      form_processed_ok(path_after_save)
    else
      form_processed_with_error(view_for_new)
    end
  end

  # patch /admin/users/:id
  def update
    if component_handler.update_user(@entity, entity_parameters, profile_parameters)
      form_processed_ok(path_after_save)
    else
      form_processed_with_error(view_for_edit)
    end
  end

  # post /admin/users/:id/authenticate
  def authenticate
    unless @entity.super_user?
      cookies['pt'] = {
        value: cookies['token'],
        expires: 1.year.from_now,
        domain: :all,
        httponly: true
      }
      create_token_for_user(@entity)
    end

    redirect_to my_path
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def entity_parameters
    excluded = @entity&.super_user? ? User.sensitive_parameters : []
    permitted = User.entity_parameters - excluded
    params.require(:user).permit(permitted)
  end

  def creation_parameters
    parameters = params.require(:user).permit(User.entity_parameters)
    parameters.merge(tracking_for_entity)
  end

  def profile_parameters
    if params.key?(:profile)
      permitted = Biovision::Components::Users::ProfileHandler.allowed_parameters
      params.require(:profile).permit(permitted)
    else
      {}
    end
  end
end
