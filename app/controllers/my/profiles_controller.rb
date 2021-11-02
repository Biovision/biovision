# frozen_string_literal: true

# Managing profile for current user
class My::ProfilesController < ApplicationController
  include Authentication
  include ProcessedForms
  include RestrictedAccess

  before_action :redirect_authorized_user, only: %i[new create]
  before_action :restrict_anonymous_access, except: %i[check new create]

  # post /my/profile/check
  def check
    code = Code.active.find_by(body: param_from_request(:code))
    registration_handler.check(creation_parameters.to_h, code)
  end

  # get /my/profile/new
  def new
    @entity = User.new

    render :closed unless component_handler.registration_open?
  end

  # post /my/profile
  def create
    if params[:agree]
      metric = Biovision::Components::UsersComponent::METRIC_REGISTRATION_BOT
      component_handler.register_metric(metric)
      redirect_to root_path, alert: t('.are_you_bot')
    else
      create_user
    end
  end

  # get /my/profile
  def show
  end

  # get /my/profile/edit
  def edit
  end

  # patch /my/profile
  def update
    @entity = current_user
    if component_handler.update_user(@entity, user_parameters, profile_parameters)
      flash[:notice] = t('.success')
      form_processed_ok(my_path)
    else
      form_processed_with_error(:edit)
    end
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def redirect_authorized_user
    redirect_to my_path if current_user.is_a?(User)
  end

  def registration_handler
    handler_class = Biovision::Components::Users::RegistrationHandler
    @registration_handler ||= handler_class.new(component_handler)
  end

  def create_user
    code = Code.active.find_by(body: param_from_request(:code))
    registration_handler.handle(creation_parameters.to_h, code)
    @entity = registration_handler.user

    if @entity.persisted?
      user_created
    else
      form_processed_with_error(:new, @entity.errors.full_messages)
    end
  end

  def creation_parameters
    parameters = params.require(:user).permit(User.new_profile_parameters)
    parameters.merge!(tracking_for_entity)
    if cookies['r']
      parameters[:inviter] = User.find_by(referral_link: cookies['r'])
    end

    parameters
  end

  def user_parameters
    sensitive = sensitive_parameters
    editable = User.profile_parameters + sensitive
    parameters = params.require(:user).permit(editable)

    filter_parameters(parameters.to_h, sensitive)
  end

  def sensitive_parameters
    if current_user.authenticate param_from_request(:password)
      User.sensitive_parameters
    else
      []
    end
  end

  def profile_parameters
    if params.key?(:profile)
      list = Biovision::Components::Users::ProfileHandler.permitted_for_request
      params.require(:profile).permit(list)
    else
      {}
    end
  end

  # @param [Hash] parameters
  # @param [Array] sensitive
  def filter_parameters(parameters, sensitive)
    sensitive.each { |sp| parameters.except! sp if sp.blank? }
    if parameters.key?(:email) && parameters[:email] != current_user.email
      parameters[:email_confirmed] = false
    end
    if parameters.key?(:phone) && parameters[:phone] != current_user.phone
      parameters[:phone_confirmed] = false
    end

    parameters
  end

  def user_created
    create_token_for_user(@entity)
    cookies.delete('r', domain: :all)

    redirect_after_creation
  end

  def redirect_after_creation
    return_path = cookies['return_path'].to_s
    return_path = my_profile_path unless return_path[0] == '/'
    cookies.delete 'return_path', domain: :all

    form_processed_ok(return_path)
  end
end
