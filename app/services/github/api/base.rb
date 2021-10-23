# frozen_string_literal: true

module Github
  module Api
    class Base
      def client
        @client ||= Octokit::Client.new(access_token: access_token)
      end

      def user
        @user ||= client.user
      end

      private

      def access_token
        ENV.fetch('GITHUB_ACCESS_TOKEN')
      end

      def repo_issues
        ENV.fetch('GITHUB_REPO_ISSUES')
      end

      def repo_org
        ENV.fetch('GITHUB_ORG')
      end
    end
  end
end
