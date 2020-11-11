# frozen_string_literal: true

# Common administrative controller
class AdminController < ApplicationController
  before_action :restrict_access

  private

  def restrict_access
    error = t('admin.errors.unauthorized.message')

    handle_http_401(error) unless component_handler.allow?
  end
end
