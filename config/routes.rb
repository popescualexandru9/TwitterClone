# frozen_string_literal: true

Rails.application.routes.draw do
  root to:"application#index"

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

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

end
