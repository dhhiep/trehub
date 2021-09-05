# frozen_string_literal: true

module Github
  class Fetcher
    def fetch(options = {})
      total_pages = options[:total_pages].presence || 1
      per_page = options[:per_page].presence || 100

      issues =
        (1..total_pages).to_a.reduce({}) do |accumulator, page|
          accumulator.merge(project_issues(page: page, per_page: per_page))
        end

      cards =
        (1..total_pages).to_a.reduce({}) do |accumulator, page|
          accumulator.merge(project_cards(page: page, per_page: per_page))
        end

      issues.each do |issue_number, issue_data|
        card_data = cards[issue_number] || {}

        issues[issue_number] = issue_data.merge(card_data)
      end

      issues
    end

    private

    def project_cards(options = {})
      page = options[:page].presence || 1
      per_page = options[:per_page].presence || 100
      puts "Fetching project cards page: #{page} - per page: #{per_page}"

      Github::Api::Project.new.project_cards(page: page, per_page: per_page)
    end

    def project_issues(options = {})
      page = options[:page].presence || 1
      per_page = options[:per_page].presence || 100
      puts "Fetching project issues page: #{page} - per page: #{per_page}"

      Github::Api::Issue.new.issues(page: page, per_page: per_page, state: :all)
    end
  end
end
