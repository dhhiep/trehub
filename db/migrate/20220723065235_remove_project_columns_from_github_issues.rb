# frozen_string_literal: true

class RemoveProjectColumnsFromGithubIssues < ActiveRecord::Migration[6.1]
  def change
    remove_column :github_issues, :project_column, :string
    remove_column :github_issues, :project_name, :string
  end
end
