# frozen_string_literal: true

class AddColumnPrOpeningAndPrClosedToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :github_issues, :pr_opening, :integer, default: 0
    add_column :github_issues, :pr_closed, :integer, default: 0
  end
end
