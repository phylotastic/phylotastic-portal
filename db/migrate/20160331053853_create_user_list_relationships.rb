class CreateUserListRelationships < ActiveRecord::Migration
  def change
    create_table :user_list_relationships do |t|
      t.integer :user_id
      t.integer :uploaded_list_id
      t.timestamps null: false
    end
    add_index :user_list_relationships, :user_id
    add_index :user_list_relationships, :uploaded_list_id
    add_index :user_list_relationships, [:user_id, :uploaded_list_id], unique: true
  end
end
