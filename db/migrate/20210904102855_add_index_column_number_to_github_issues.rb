# frozen_string_literal: true

class AddIndexColumnNumberToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_index :github_issues, :number, unique: true
  end
end
