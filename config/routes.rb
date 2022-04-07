# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users
  resources :tweets

  namespace :api do
    resources :users
    resources :tweets do
      resources :likes
    end
    resources :friends
  end
end
