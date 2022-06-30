# frozen_string_literal: true

module Github
  module Api
    class IssueTimeline < Base
      class << self
        def issue_timeline(number, options = {})
          new.issue_timeline(number, options)
        end
      end

      def issue_timeline(number, options = {})
        options[:per_page] ||= 100

        issue_timeline = client.issue_timeline(repo_issues, number, options) rescue []

        formatter(issue_timeline)
      end

      private

      def formatter(data)
        {
          pull_request_url: pr_url(data),
          total_open_pull_requests: open_pull_requests(data).count,
          total_merged_pull_requests: merged_pull_requests(data).count,
          total_pull_requests: pull_requests(data).count,
        }
      end

      def pr_url(data)
        pr_urls =
          pull_requests(data).map do |timeline|
            next if timeline.to_h.dig(:source, :issue, :state) == 'closed'

            timeline.to_h.dig(:source, :issue, :pull_request, :html_url)
          end

        pr_urls.compact.uniq.first
      end

      def open_pull_requests(data)
        pull_requests(data).select do |timeline|
          timeline.to_h.dig(:source, :issue, :state) == 'open'
        end
      end

      def merged_pull_requests(data)
        pull_requests(data).select do |timeline|
          timeline.to_h.dig(:source, :issue, :state) == 'closed'
        end
      end

      def pull_requests(data)
        @pull_requests ||=
          data.select do |obj|
            obj[:event] == 'cross-referenced' && obj.to_h.dig(:source, :issue, :pull_request).present?
          end
      end
    end
  end
end
