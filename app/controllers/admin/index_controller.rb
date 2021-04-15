# frozen_string_literal: true

# Administrative home page
class Admin::IndexController < AdminController
  # get /admin
  def index
  end

  private

  def restrict_access
    role_name = "#{component_handler.slug}.admin"
    error = t('admin.errors.unauthorized.missing_role', role: role_name)

    handle_http_401(error) unless component_handler.permit?('admin')
  end
end
