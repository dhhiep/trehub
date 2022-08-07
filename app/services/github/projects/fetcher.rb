# frozen_string_literal: true

module Github
  module Projects
    class Fetcher
      def self.call
        new.call
      end

      def call
        project_cards = Github::Api::Project.project_cards
        project_cards.each do |issue_number, card_data|
          data = {
            project: card_data[:project_name],
            column: card_data[:project_column],
          }

          card = Card.where(issue_number: issue_number).first_or_initialize
          card.update(data)
        end

        Configuration.project_cards_updated_at = Time.current
      end
    end
  end
end
