# frozen_string_literal: true

Rails.application.routes.draw do
  mount Lookbook::Engine, at: '/lookbook' if Rails.env.development?

  resources :toggles
  resources :selects

  root 'application#index'
end
