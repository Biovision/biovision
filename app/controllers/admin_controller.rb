# frozen_string_literal: true

# Common administrative controller
class AdminController < ApplicationController
  before_action :restrict_access

  private

  def restrict_access
    user_action = "#{controller_name}.#{role_end_from_action}"
    role_name = "#{component_handler.slug}.#{user_action}"
    error = t('admin.errors.unauthorized.missing_role', role: role_name)

    handle_http_401(error) unless component_handler.permit?(user_action)
  end

  def role_end_from_action
    role = action_to_role_map.select { |k| k.include?(action_name) }.values.last
    role || 'default'
  end

  def action_to_role_map
    {
      %w[index show search] => 'view',
      %w[new create edit update destroy] => 'edit'
    }
  end
end
