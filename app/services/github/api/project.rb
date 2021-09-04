# frozen_string_literal: true

module Github
  module Api
    class Project < Base
      # List projects for a repository
      #
      # Requires authenticated client
      #
      # @return [Array<Sawyer::Resource>] Repository projects
      # @see https://developer.github.com/v3/projects/#list-repository-projects
      # @example
      #   projects(page: 2, per_page: 50)
      def projects(options = {})
        @projects ||= client.projects(repo, options)

        projects_formatter(@projects)
      end

      # All projects columns for a repository
      #
      # @return [Array<Sawyer::Resource>] List of project columns
      # @see https://developer.github.com/v3/projects/columns/#list-project-columns
      # @example
      #   project_columns(page: 2, per_page: 50)
      def project_columns(options = {})
        @project_columns ||=
          projects(per_page: 100).map do |project|
            columns = client.project_columns(project[:id], options)

            columns_formatter(project, columns)
          end

        project_columns_formatter(@project_columns)
      end

      # All projects cards for a repository
      #
      # @return [Array<Sawyer::Resource>] Cards in the column
      # @see https://developer.github.com/v3/projects/cards/#list-project-cards
      # @example
      #   project_cards(page: 2, per_page: 50)
      def project_cards(options = {})
        @project_cards ||=
          project_columns(per_page: 100).map do |column|
            cards = client.column_cards(column[:id], options)

            cards_formatter(column, cards)
          end

        project_cards_formatter(@project_cards)
      end

      private

      def projects_formatter(projects)
        projects.map do |project|
          {
            id: project[:id].to_i,
            name: project[:name],
          }
        end
      end

      def project_columns_formatter(columns)
        columns.flatten
      end

      def columns_formatter(project, columns)
        columns.map do |column|
          {
            project_id: project[:id],
            project_name: project[:name],

            id: column[:id].to_i,
            name: column[:name],
          }
        end
      end

      def project_cards_formatter(cards)
        cards.flatten.reduce({}) do |accumulator, card|
          accumulator.merge(card[:number] => card)
        end
      end

      def cards_formatter(column, cards)
        cards.map do |card|
          issue_number = extract_card_issue_number(card)
          next if issue_number.blank?

          {
            project_name: column[:project_name],
            project_column: column[:name],
            number: issue_number.to_i,
          }
        end
      end

      def extract_card_issue_number(card)
        card.content_url.to_s.match(/\/issues\/(\d+)/).to_a[1]
      end
    end
  end
end
