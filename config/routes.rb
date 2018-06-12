# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    unauthenticated do
      root 'devise/sessions#new'
    end
    authenticated do
      root 'tabs#index'
    end
  end

  namespace :api do
    resources :bills, only: :create do
      collection do
        resources :reminders, only: :create
      end
    end
  end

  namespace :admin do
    authenticate :user, ->(u) { u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
    resources :sepas, only: [:index, :create] do
      collection do
        post :create_membership_invoices_xml
      end
    end
    resources :users
    resources :products
    resources :statistics, only: :index
    resources :tabs, only: %i[index update]
    resources :tab_items, only: %i[create destroy update]
    resources :bills, only: %i[index show create update] do
      resource :reminder, only: :show, controller: 'reminder'
      collection do
        resources :export, only: :index, controller: 'export'
      end
    end
    resources :shops, only: :index
    resources :carts, only: %i[new update destroy] do
      member do
        put :checkout
      end
    end
  end

  resources :carts, only: %i[update destroy] do
    member do
      put :checkout
    end
  end
  resources :tabs, only: %i[index update]
  resources :products, only: :index
  resources :tab_items, only: :create
  resources :bills, only: %i[index show]
  resources :users, only: %i[edit update]
  resource :policy do
    collection do
      get :imprint
      get :data_policy
    end
  end
end
