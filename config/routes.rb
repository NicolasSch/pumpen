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

  resources :tab, only: :index
  resources :tab_item, only: :create
  resources :user, only: :index
end
