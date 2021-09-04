# frozen_string_literal: true

class ChangeDefaultValueForGithubIssuesStatus < ActiveRecord::Migration[6.1]
  def up
    change_column :github_issues, :status, :string, default: nil
  end

  def down
    change_column :github_issues, :status, :string, default: :todo
  end
end
