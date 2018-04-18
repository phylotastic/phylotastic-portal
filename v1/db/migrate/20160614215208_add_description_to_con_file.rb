class AddDescriptionToConFile < ActiveRecord::Migration
  def change
    add_column :con_files, :description, :text
    add_column :con_files, :method, :integer
    add_index :con_files, :description
  end
end
