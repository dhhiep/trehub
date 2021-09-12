# frozen_string_literal: true

class AddColumnCreatedByToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :github_issues, :created_by, :string
  end
end
