# frozen_string_literal: true

namespace :github do
  namespace :projects do
    desc 'Fetch project cards from Github'
    # bundle exec rake github:projects:fetcher
    task fetcher: :environment do
      Github::Projects::Fetcher.call
    end
  end
end
