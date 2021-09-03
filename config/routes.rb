# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :github_issues

  root to: 'github_issues#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :github_issues, only: %i[index show]
    end
  end
end
