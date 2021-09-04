# frozen_string_literal: true

class AddColumnProjectColumnAndProjectNameToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :github_issues, :project_column, :string
    add_column :github_issues, :project_name, :string
  end
end
