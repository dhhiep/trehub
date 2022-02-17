class CreateConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :configurations do |t|
      t.string :key, null: false, unique: true
      t.text :value

      t.timestamps
    end

    add_index :configurations, :key, unique: true
  end
end
