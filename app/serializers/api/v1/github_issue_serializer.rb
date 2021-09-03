# frozen_string_literal: true

module Api
  module V1
    class GithubIssueSerializer < Api::BaseSerializer
      attributes :id, :name
    end
  end
end
