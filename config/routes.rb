# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  defaults format: :json do
    resources :tasks, except: %i[new edit], param: :slug
    resource :sessions, only: %i[create destroy]
    resources :users, only: %i[index create]
    resources :comments, only: :create
    resources :preferences, only: %i[show update]
  end

  root "home#index"
  get "*path", to: "home#index", via: :all
end
