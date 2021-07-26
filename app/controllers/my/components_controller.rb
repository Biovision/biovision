# frozen_string_literal: true

# User-side component handling
class My::ComponentsController < ProfileController
  before_action :restrict_component_access, except: :index

  # get /my/components
  def index
    @collection = BiovisionComponent.list_for_user
  end

  # get /my/components/:slug
  def show
  end

  private

  def restrict_component_access
    slug = params[:slug]
    @handler = Biovision::Components::BaseComponent.handler(slug, current_user)
    role_name = "#{@handler.slug}.default"
    error = t('admin.errors.unauthorized.missing_role', role: role_name)

    handle_http_401(error) unless @handler.permit?(role_name)
  end
end
