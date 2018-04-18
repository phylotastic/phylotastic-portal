class AddNameToConLinks < ActiveRecord::Migration
  def change
    add_column :con_links, :name, :string
    add_index :con_links, :name
  end
end
