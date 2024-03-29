# frozen_string_literal: true

# Adds method for restricting access
module RestrictedAccess
  extend ActiveSupport::Concern

  private

  # Restrict access for anonymous users
  def restrict_anonymous_access
    return unless current_user.nil?

    handle_http_401(t('application.errors.restricted_access'))
  end

  def restrict_access
    user_action = role_end_from_action
    role_name = "#{component_handler.slug}.#{user_action}"
    error = t('admin.errors.unauthorized.missing_role', role: role_name)

    handle_http_401(error) unless component_handler.permit?(user_action)
  end

  def role_end_from_action
    role = action_to_role_map.select { |k| k.include?(action_name) }.values.last
    role || 'default'
  end

  def action_to_role_map
    view = %w[index show search]
    edit = %w[create destroy edit new priority toggle update]
    {
      view => "#{controller_name}.view",
      edit => "#{controller_name}.edit"
    }
  end
end
