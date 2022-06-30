# frozen_string_literal: true

class AddColumnFavouriteToGithubIssues < ActiveRecord::Migration[6.1]
  def change
    add_column :github_issues, :favourite, :boolean, default: false
  end
end
