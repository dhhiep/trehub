# frozen_string_literal: true

module Github
  class Fetcher
    def fetch
      project_issues.each do |issue_number, issue_data|
        card_data = project_cards[issue_number] || {}

        project_issues[issue_number] = issue_data.merge(card_data)
      end

      project_issues
    end

    private

    def project_cards(per_page: 100)
      @project_cards ||= Github::Api::Project.new.project_cards(per_page: per_page)
    end

    def project_issues(per_page: 100)
      @project_issues ||= Github::Api::Issue.new.issues(per_page: per_page)
    end
  end
end
