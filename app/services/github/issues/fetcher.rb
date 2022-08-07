# frozen_string_literal: true

module Github
  module Issues
    class Fetcher
      def self.call(options = {})
        new(options).call
      end

      def initialize(options = {})
        @options = options
      end

      def call
        issues = active_issues
        issues.each do |issue_number, issue_data|
          puts "Processing issue ##{issue_number} ..."

          github_issue = GithubIssue.where(number: issue_number).first_or_initialize
          data = issue_data_builder(issue_data)
          github_issue.update(data)
        end

        Configuration.github_issues_updated_at = Time.current
      end

      private

      attr_reader :options

      def issue_state
        options[:state].presence || :open
      end

      def active_issues
        issues = Github::Api::Issue.new.issues(state: issue_state)

        tracked_issue_numbers = GithubIssue.active.where.not(number: issues.keys).pluck(:number)
        tracked_issue_numbers.concurrent_map do |issue_number|
          issue_data = Github::Api::Issue.new.issue(issue_number) rescue nil
          next if issue_data.blank?

          issues.merge!(issue_data[:number] => issue_data)
        end

        puts "issues length #{issues.length}"
        issues
      end

      def issue_data_builder(issue_data)
        {
          name: issue_data[:name],
          status: issue_data[:status],
          assignees: issue_data[:assignees].map { |assignee| assignee[:name] }.join(', '),
          label: issue_data[:labels].map { |label| label[:name] }.join(', '),
          milestone: issue_data[:milestone] || GithubIssue::BACKLOG_DATE,
          due_date: issue_data[:due_date],
          pr_url: issue_data.dig(:pull_requests, :pull_request_url),
          pr_opening: issue_data.dig(:pull_requests, :total_open_pull_requests).to_i,
          pr_closed: issue_data.dig(:pull_requests, :total_merged_pull_requests).to_i,
          created_by: issue_data[:created_by],
        }
      end
    end
  end
end
