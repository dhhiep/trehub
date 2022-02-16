# frozen_string_literal: true

if Rails.env.development?
  rufus_scheduler = Rufus::Scheduler.new

  rufus_scheduler.every '2m' do
    puts '[Scheduler] Fetching new issues ...'
    GithubIssue.sync_remote_issues(total_pages: 1)
  end
end
