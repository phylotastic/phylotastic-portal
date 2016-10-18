class AddTempIdToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :temp_id, :string
    add_index :trees, :temp_id
  end
end
