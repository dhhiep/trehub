# frozen_string_literal: true

class AddColumnVerifiedToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :github_issues, :verified, :boolean, default: false
  end
end
