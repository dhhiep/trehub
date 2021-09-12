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
        @issues ||= client.issues(repo, options)

        formatter(@issues)
      end

      private

      def formatter(data)
        issues =
          data.concurrent_map do |issue|
            {
              number: issue[:number],
              name: issue[:title],
              status: issue[:state],
              assignees: assignees(issue),
              labels: labels(issue),
              pull_requests: pull_requests(issue),
              milestone: issue.to_h.dig(:milestone, :due_on),
              created_by: issue.to_h.dig(:user, :login),
            }
          end

        issues.reduce({}) do |accumulator, issue|
          accumulator.merge(issue[:number] => issue)
        end
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
    end
  end
end
