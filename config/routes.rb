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
    resources :shops, only: :index
  end

  resources :tabs, only: [:index, :update]
  resources :products, only: :index
  resources :tab_items, only: :create
  resources :users, only: :index
end
