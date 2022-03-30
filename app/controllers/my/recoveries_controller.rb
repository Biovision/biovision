# frozen_string_literal: true

# Password recovery for users
class My::RecoveriesController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user
  before_action :find_user, only: :create

  # get /my/recovery
  def show
  end

  # post /my/recovery
  def create
    if @user.nil? || @user.email.blank?
      redirect_to my_recovery_path, alert: t('.impossible')
    else
      component_handler.send_recovery(@user)
      redirect_to my_recovery_path, notice: t('.completed')
    end
  end

  # patch /my/recovery
  def update
    code = Code.find_by(body: param_from_request(:code))
    if component_handler.valid_recovery?(code)
      reset_password(code)
    else
      redirect_to my_recovery_path, alert: t('.invalid_code')
    end
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def find_user
    @user = User.with_email(param_from_request(:email)).first
  end

  # @param [Code] code
  def reset_password(code)
    if component_handler.reset_password(code, new_user_parameters)
      create_token_for_user code.user
      redirect_to my_path, notice: t('my.recoveries.update.success')
    else
      flash[:error] = t('my.recoveries.update.failed')
      render :show, status: :bad_request
    end
  end

  def new_user_parameters
    parameters = params.require(:user).permit(:password, :password_confirmation)
    if parameters[:password].blank?
      parameters[:password] = nil
      parameters[:password_confirmation] = nil
    end
    parameters
  end
end
