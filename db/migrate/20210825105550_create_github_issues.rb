# frozen_string_literal: true

class CreateGithubIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :github_issues do |t|
      t.string :name
      t.integer :number
      t.string :status, default: :todo
      t.string :assignees
      t.string :label
      t.datetime :milestone
      t.boolean :track, default: false

      t.timestamps null: false
    end
  end
end
