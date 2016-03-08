class CreateWatchRelationships < ActiveRecord::Migration
  def change
    create_table :watch_relationships do |t|
      t.integer :user_id
      t.integer :tree_id

      t.timestamps null: false
    end
    add_index :watch_relationships, :user_id
    add_index :watch_relationships, :tree_id
    add_index :watch_relationships, [:user_id, :tree_id], unique: true
  end
end
