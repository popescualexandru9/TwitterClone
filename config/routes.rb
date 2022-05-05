# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users
  resources :tweets

  post '/graphql', to: 'graphql#index'
  post '/auth/login', to: 'authentication#login'

  namespace :api do
    resources :users
    resources :tweets do
      get :my, on: :collection # /api/tweets/my
      resources :likes
    end
    resources :friends
  end
end
