Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    unauthenticated do
      root 'devise/sessions#new'
    end
    authenticated do
      root 'users#index'
    end
  end

  resources :user, only: :index
end
