# frozen_string_literal: true

# Authentication with form and OAuth
class AuthenticationController < ApplicationController
  include Authentication

  before_action :redirect_authenticated_user, except: %i[new destroy]

  # get /login
  def new
  end

  # post /login
  def create
    handler = Biovision::Components::UsersComponent[find_user]
    if handler.authenticate(params[:password], tracking_for_entity)
      auth_success(handler.user)
    else
      auth_failed
    end
  end

  # delete /logout
  def destroy
    deactivate_token if current_user

    redirect_to root_path
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end

  def find_user
    login = param_from_request(:login).downcase
    user = User.find_by(slug: login)

    # Try to authenticate by email, if login does not match anything
    if user.nil? && login.index('@').to_i.positive?
      user = User.with_email(login).first
    end

    user
  end

  # @param [User] user
  def auth_success(user)
    create_token_for_user(user)

    from = param_from_request(:from)
    next_page = from =~ %r{\A/[^/]} ? from : my_path
    render json: { links: { next: next_page } }
  end

  def auth_failed
    response = { errors: [{ title: t('authentication.create.failed') }] }
    render json: response, status: :unauthorized
  end
end
