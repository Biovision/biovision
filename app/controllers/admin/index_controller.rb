# frozen_string_literal: true

# Administrative home page
class Admin::IndexController < AdminController
  # get /admin
  def index
    return if Biovision::Components::BaseComponent.privileged?(current_user)

    handle_http_401
  end
end
