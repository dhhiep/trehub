# frozen_string_literal: true

module Api
  module V1
    class GithubIssuesController < Api::BaseController
      def index
        # Default get all github_issues in Vietnam
        @github_issues = GithubIssue.all
        render json: serialize_resource(@github_issues)
      end

      def show
        @github_issue = GithubIssue.find(params[:id].presence)
        render json: serialize_resource(@github_issue)
      end

      private

      def resource_serializer
        GithubIssueSerializer
      end
    end
  end
end
