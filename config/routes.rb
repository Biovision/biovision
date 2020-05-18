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
    end

    namespace :my do
      get '/' => 'index#index'

      resource :profile, except: :destroy, concerns: :check
      resource :confirmation, :recovery, only: %i[show create update]
    end
  end
end
