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

  concern :search do
    get :search, on: :collection
  end

  concern :stories do
    post 'stories/:slug' => :collection_story, on: :collection, as: :story
    post 'stories/:slug' => :member_story, on: :member, as: :story
  end

  root 'index#index'
end
