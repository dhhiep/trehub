class CreateGithubRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table :github_repositories do |t|
      t.string :repo_id
      t.string :name
      t.string :url
      t.integer :pr_opening, default: 0
      t.boolean :track, default: false
      t.boolean :verified, default: false

      t.timestamps
    end
  end
end
