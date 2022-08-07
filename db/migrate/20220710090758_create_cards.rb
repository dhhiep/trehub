class CreateCards < ActiveRecord::Migration[6.1]
  def change
    create_table :cards do |t|
      t.integer :issue_number
      t.string :project
      t.string :column
      t.string :status
      t.text :note

      t.timestamps
    end
  end
end
