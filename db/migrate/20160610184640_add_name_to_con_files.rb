class AddNameToConFiles < ActiveRecord::Migration
  def change
    add_column :con_files, :name, :string
    add_index :con_files, :name
  end
end
