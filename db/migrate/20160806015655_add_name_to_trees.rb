class AddNameToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :name, :string
    add_index :trees, :name
  end
end
