# frozen_string_literal: true

Rails.application.routes.draw do
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  # Handling errors
  match '/400' => 'errors#bad_request', via: :all
  match '/401' => 'errors#unauthorized', via: :all
  match '/403' => 'errors#forbidden', via: :all
  match '/404' => 'errors#not_found', via: :all
  match '/422' => 'errors#unprocessable_entity', via: :all
  match '/500' => 'errors#internal_server_error', via: :all

  # Contact component
  scope 'contact', controller: :contact do
    get '/' => :index, as: :contact
    get 'feedback'
    post 'feedback_messages' => :create_feedback_message
  end

  controller :legal do
    get 'tos'
    get 'privacy'
  end

  # Users component
  controller :authentication do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  scope 'u/:slug', controller: :users, constraints: { slug: %r{[^/]+} } do
    get '/' => :show, as: :user
    put 'follow' => :follow, as: :follow_user
    delete 'follow' => :unfollow, as: nil
    put 'ban' => :ban, as: :ban_user
    delete 'ban' => :unban, as: nil
  end

  namespace :admin do
    get '/' => 'index#index'

    scope :components, controller: :components do
      get '/' => :index, as: :components
      scope ':slug' do
        get '/' => :show, as: :component
        get 'settings' => :settings, as: :component_settings
        patch 'settings' => :update_settings, as: nil
        patch 'parameters' => :update_parameter, as: :component_parameters
        get 'privileges' => :privileges, as: :component_privileges
        patch 'privileges' => :update_privileges, as: nil
        put 'administrators/:user_id' => :add_administrator, as: :component_administrators
        delete 'administrators/:user_id' => :remove_administrator, as: nil
        get 'images' => :images, as: :component_images
        post 'images' => :create_image, as: nil
        post 'ckeditor'
      end
    end

    # Track component
    resources :agents, :ip_addresses, only: :index

    # Content component
    resources :dynamic_pages, :dynamic_blocks, concerns: %i[check toggle]
    resources :navigation_groups, concerns: :check do
      member do
        put 'dynamic_pages/:page_id' => :add_page, as: :dynamic_page
        delete 'dynamic_pages/:page_id' => :remove_page
        post 'dynamic_pages/:page_id/priority' => :page_priority, as: :page_priority
      end
    end

    resources :users, concerns: %i[check toggle]
  end

  namespace :my do
    get '/' => 'index#index'

    resource :profile, except: :destroy, concerns: :check
    resource :confirmation, :recovery, only: %i[show create update]
  end

  get ':slug' => 'fallback#show', constraints: { slug: /.+/ }
end
