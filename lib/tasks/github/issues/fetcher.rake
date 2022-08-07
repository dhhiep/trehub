# frozen_string_literal: true

namespace :github do
  namespace :issues do
    desc 'Fetch new issues from Github'
    # bundle exec rake github:issues:fetcher
    task fetcher: :environment do
      Github::Issues::Fetcher.call
    end
  end
end
