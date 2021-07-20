# frozen_string_literal: true

# Main page for user
class My::IndexController < ProfileController
  # get /my
  def index
  end

  private

  def component_class
    Biovision::Components::UsersComponent
  end
end
