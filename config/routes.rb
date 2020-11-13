# frozen_string_literal: true

Rails.application.routes.draw do
  concern :check do
    post :check, on: :collection, defaults: { format: :json }
  end

  concern :toggle do
    post :toggle, on: :member, defaults: { format: :json }
  end

  concern :priority do
    post :priority, on: :member, defaults: { format: :json }
  end

  concern :removable_image do
    delete :image, action: :destroy_image, on: :member, defaults: { format: :json }
  end

  concern :lock do
    member do
      put :lock, defaults: { format: :json }
      delete :lock, action: :unlock, defaults: { format: :json }
    end
  end

  scope '(:locale)', constraints: { locale: /ru|en/ } do
    root 'index#index'

    # Handling errors
    match '/400' => 'errors#bad_request', via: :all
    match '/401' => 'errors#unauthorized', via: :all
    match '/403' => 'errors#forbidden', via: :all
    match '/404' => 'errors#not_found', via: :all
    match '/422' => 'errors#unprocessable_entity', via: :all
    match '/500' => 'errors#internal_server_error', via: :all

    controller :authentication do
      get 'login' => :new
      post 'login' => :create
      delete 'logout' => :destroy
      get 'auth/:provider/callback' => :auth_callback, as: :auth_callback
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
          put 'users/:user_id/privileges/:privilege_slug' => :add_privilege, as: :component_privilege
          delete 'users/:user_id/privileges/:privilege_slug' => :remove_privilege, as: nil
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

      resources :users, only: %i[index show]
    end

    namespace :my do
      get '/' => 'index#index'

      resource :profile, except: :destroy, concerns: :check
      resource :confirmation, :recovery, only: %i[show create update]
    end
  end
end
