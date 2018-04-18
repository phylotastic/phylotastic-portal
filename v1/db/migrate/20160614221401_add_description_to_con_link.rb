class AddDescriptionToConLink < ActiveRecord::Migration
  def change
    add_column :con_links, :description, :text
    add_index :con_links, :description
  end
end
