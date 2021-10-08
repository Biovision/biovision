# frozen_string_literal: true

# Errors
class ErrorsController < ApplicationController
  before_action :set_message

  # get /400
  def bad_request
    render :error
  end

  # get /401
  def unauthorized
    render :error
  end

  # get /403
  def forbidden
    render :error
  end

  # get /422
  def unprocessable_entity
    render :error
  end

  # get /500
  def internal_server_error
    render :error
  end

  private

  def set_message
    @message = t("application.errors.#{action_name}")
  end
end
