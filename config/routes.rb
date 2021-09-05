# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :github_issues do
    member do
      post :toggle_track
      post :toggle_verified
    end

    collection do
      post :mark_all_verified
      post :fetch_github_issues
      post :mark_all_verified
    end
  end

  root to: 'github_issues#index'

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resources :github_issues, only: %i[index show]
    end
  end
end
