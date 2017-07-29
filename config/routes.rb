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

  namespace :admin do
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
    resources :users
    resources :products
    resources :statistics, only: :index
    resources :tabs, only: [:index, :update]
    resources :bills, only: [:index, :show, :create, :update]
    resources :shops, only: :index
    resources :carts, only: [:new, :update, :destroy] do
      member do
        put :checkout
      end
    end
  end

  resources :carts, only: [:update, :destroy] do
    member do
      put :checkout
    end
  end
  resources :tabs, only: [:index, :update]
  resources :products, only: :index
  resources :tab_items, only: [:create, :update, :destroy]
  resources :bills, only: [:index, :show]
  resources :users, only: [:edit, :update]
end
