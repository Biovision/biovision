# frozen_string_literal: true

# Sending and checking email confirmation codes
class My::ConfirmationsController < ApplicationController
  include Authentication

  before_action :redirect_confirmed_user, only: %i[create update]

  # get /my/confirmation
  def show
  end

  # post /my/confirmation
  def create
    if current_user.email.blank?
      redirect_to edit_my_profile_path, notice: t('.set_email')
    else
      component_handler.send_email_confirmation(current_user)

      redirect_to my_confirmation_path, notice: t('.success')
    end
  end

  # patch /my/confirmation
  def update
    code = Code.find_by(body: param_from_request(:code))
    if component_handler.valid_email_confirmation?(code)
      component_handler.activate_email_confirmation(code)
      create_token_for_user(code.user)
      redirect_to my_path
    else
      flash[:error] = t('.invalid_code')
      redirect_to my_confirmation_path
    end
  end

  protected

  def component_class
    Biovision::Components::UsersComponent
  end

  def redirect_confirmed_user
    redirect_to(my_path) if current_user&.email_confirmed?
  end
end
