class AddDescriptionToConLink < ActiveRecord::Migration
  def change
    add_column :con_links, :description, :text
  end
end
