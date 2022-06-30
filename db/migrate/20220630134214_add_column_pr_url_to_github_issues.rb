# frozen_string_literal: true

class AddColumnPrUrlToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :github_issues, :pr_url, :string
  end
end
