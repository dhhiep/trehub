# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions' }

  resources :github_issues do
    member do
      post :toggle_track
      post :toggle_favourite
      post :toggle_verified
    end

    collection do
      post :fetch_github_issues
      post :mark_all_verified
    end
  end

  resources :github_repositories do
    member do
      post :toggle_track
      post :toggle_verified
    end

    collection do
      post :fetch_github_repositories
      post :mark_all_verified
    end
  end

  root to: 'github_issues#index'
end
