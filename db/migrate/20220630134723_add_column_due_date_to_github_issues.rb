# frozen_string_literal: true

class AddColumnDueDateToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :github_issues, :due_date, :string
  end
end
