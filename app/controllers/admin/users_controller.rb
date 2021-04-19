# frozen_string_literal: true

# Administrative part for handling users
class Admin::UsersController < AdminController
  include Authentication
  include CrudEntities
  include ToggleableEntity

  before_action :set_entity, except: %i[check create index new search]

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

  # get /admin/users/:id/roles
  def roles
    if current_user&.super_user?
      @components = BiovisionComponent.list_for_administration
    else
      handle_http_401
    end
  end

  # put /admin/users/:id/roles/:role_id
  def add_role
    if current_user&.super_user?
      role = Role.find_by(id: params[:role_id])
      @entity.add_role(role)
    end

    head :no_content
  end

  # delete /admin/users/:id/roles/:role_id
  def remove_role
    if current_user&.super_user?
      role = Role.find_by(id: params[:role_id])
      @entity.remove_role(role)
    end

    head :no_content
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def entity_parameters
    excluded = @entity&.super_user? ? User.sensitive_parameters : []
    permitted = User.entity_parameters(current_user) - excluded
    params.require(:user).permit(permitted)
  end

  def creation_parameters
    permitted = User.entity_parameters(current_user)
    parameters = params.require(:user).permit(permitted)
    parameters.merge(tracking_for_entity)
  end

  def profile_parameters
    if params.key?(:profile)
      list = Biovision::Components::Users::ProfileHandler.permitted_for_request
      params.require(:profile).permit(list)
    else
      {}
    end
  end
end
