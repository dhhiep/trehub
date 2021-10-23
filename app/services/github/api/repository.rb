# frozen_string_literal: true

module Github
  module Api
    class Repository < Base
      def self.all
        new.repositories
      end

      def repositories
        @repositories ||= repos_formatter(all_repositories)
      end

      private

      def repos_formatter(data)
        data.concurrent_map do |repo|
          {
            repo_id: repo[:id],
            name: repo[:full_name],
            url: repo[:html_url],
            pr_opening: client.pull_requests(repo[:full_name]).count,
          }
        end
      end

      def all_repositories
        page = 1
        repos = []

        loop do
          resp = client.org_repos(repo_org, page: page, per_page: 100)
          break if resp.blank?

          repos.concat(resp)
          page += 1
        end

        repos
      end
    end

    def pull_requests(repo)
      client.pull_requests(repo[:full_name])
    end
  end
end
