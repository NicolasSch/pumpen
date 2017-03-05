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
    resources :tab_items, only: [:create] do

    end
    resources :shops, only: :index
    resources :carts, only: [:new, :update] do
      member do
        put :checkout
      end
    end
  end

  resources :carts, only: [:update] do
    member do
      put :checkout
    end
  end
  resources :tabs, only: [:index, :update]
  resources :products, only: :index
  resources :tab_items, only: :create
  resources :users, only: :index
end
