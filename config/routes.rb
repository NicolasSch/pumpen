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
    resources :users
    resources :products
    resources :tabs, only: [:index, :update]
    resources :bills, only: [:index, :show, :create, :update]
    resources :tab_items, only: [:create] do

    end
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
  resources :tab_items, only: :create
  resources :users, only: :index
end
