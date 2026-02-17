Rails.application.routes.draw do
  resources :posts
  root to: "devise/sessions#new"
  devise_for :users, skip: [:passwords], controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :courses
  resources :users, only: [:show]
  resources :contacts, only: [:new, :create, :destroy]

  resources :conversations, only: [:new, :show, :create] do
    resources :messages, only: [:create]
  end

  resources :notifications, only: [] do
    member do
      patch :read
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "close_chat_modal", to: "conversations#close_chat_modal"
end
