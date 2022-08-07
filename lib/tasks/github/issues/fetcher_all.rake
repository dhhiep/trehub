# frozen_string_literal: true

namespace :github do
  namespace :issues do
    desc 'Fetch all issues from Github'
    # bundle exec rake github:issues:fetcher_all
    task fetcher_all: :environment do
      Github::Issues::Fetcher.call(state: :all)
    end
  end
end
