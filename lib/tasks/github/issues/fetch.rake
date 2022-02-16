# frozen_string_literal: true

namespace :github do
  namespace :issues do
    desc 'Fetch new issue from Github'
    # bundle exec rake github:issues:fetch
    task fetch: :environment do
      GithubIssue.sync_remote_issues(total_pages: 1)
    end
  end
end
