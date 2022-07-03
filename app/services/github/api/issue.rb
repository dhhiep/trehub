# frozen_string_literal: true

module Github
  module Api
    class Issue < Base
      # List issues for a repository
      #
      # @param options [Sawyer::Resource] A customizable set of options.
      # @option options [Integer] :milestone Milestone number.
      # @option options [String] :state (open) State: <tt>open</tt>, <tt>closed</tt>, or <tt>all</tt>.
      # @option options [String] :assignee User login.
      # @option options [String] :creator User login.
      # @option options [String] :mentioned User login.
      # @option options [String] :labels List of comma separated Label names. Example: <tt>bug,ui,@high</tt>.
      # @option options [String] :sort (created) Sort: <tt>created</tt>, <tt>updated</tt>, or <tt>comments</tt>.
      # @option options [String] :direction (desc) Direction: <tt>asc</tt> or <tt>desc</tt>.
      # @option options [Integer] :page (1) Page number.
      # @return [Array<Sawyer::Resource>] A list of issues for a repository.
      # @see https://developer.github.com/v3/issues/#list-issues-for-a-repository
      # @see https://developer.github.com/v3/issues/#list-issues
      # @example List issues
      #   issues(page: 2, per_page: 50)
      def issues(options = {})
        @issues ||= client.issues(repo_issues, options)

        formatter(@issues)
      end

      # Get a single issue from a repository
      #
      # @param repo [Integer, String, Repository, Hash] A GitHub repository
      # @param number [Integer] Number ID of the issue
      # @return [Sawyer::Resource] The issue you requested, if it exists
      # @see https://developer.github.com/v3/issues/#get-a-single-issue
      # @example Get issue #25 from octokit/octokit.rb
      #   Octokit.issue("octokit/octokit.rb", "25")
      def issue(number, options = {})
        issue_data = client.issue(repo_issues, number, options)

        issue_formatter(issue_data)
      end

      private

      def formatter(data)
        issues = data.concurrent_map { |issue_data| issue_formatter(issue_data) }
        issues.reduce({}) do |accumulator, issue_data|
          accumulator.merge(issue_data[:number] => issue_data)
        end
      end

      def issue_formatter(issue_data)
        {
          number: issue_data[:number],
          name: issue_data[:title],
          status: issue_data[:state],
          assignees: assignees(issue_data),
          labels: labels(issue_data),
          due_date: due_date(issue_data),
          pull_requests: pull_requests(issue_data),
          milestone: issue_data.to_h.dig(:milestone, :due_on),
          created_by: issue_data.to_h.dig(:user, :login),
        }
      end

      def assignees(issue)
        issue.assignees.map do |assignee|
          {
            name: assignee[:login],
            avatar: assignee[:avatar_url],
          }
        end
      end

      def labels(issue)
        issue.labels.map do |label|
          {
            name: label[:name],
            color: label[:color],
          }
        end
      end

      def pull_requests(issue)
        Github::Api::IssueTimeline.issue_timeline(issue[:number])
      end

      # Returns estimate date as text from issue body
      # Ex:
      #   1. Estimate 05-07-2022 => 05-07-2022
      #   2. Estimate 05.07.2022 => 05.07.2022
      #   2. Estimate 05/07/2022 => 05/07/2022
      def due_date(issue_data)
        estimate_date_matcher = issue_data[:body].to_s.match(/estimate\D*(\d+(\/|\.|-)\d+(\/|\.|-)\d+)/i)
        return if estimate_date_matcher.blank?

        estimate_date_matcher[1]
      end
    end
  end
end
