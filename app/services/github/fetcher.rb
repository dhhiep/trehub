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

      tracked_issue_numbers = GithubIssue.active.where.not(number: issues.keys).pluck(:number)
      tracked_issue_numbers.concurrent_map do |issue_number|
        issue_data = Github::Api::Issue.new.issue(issue_number) rescue nil
        next if issue_data.blank?

        issues.merge!(issue_data[:number] => issue_data)
      end

      all_cards =
        (1..1000).to_a.reduce({}) do |accumulator, page|
          result = project_cards(page: page, per_page: per_page)
          break accumulator if result.blank?

          accumulator.merge(result)
        end

      issues.each do |issue_number, issue_data|
        card_data = all_cards[issue_number] || {}

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

      Github::Api::Issue.new.issues(page: page, per_page: per_page, state: :open)
    end
  end
end
