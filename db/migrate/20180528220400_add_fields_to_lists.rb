class AddFieldsToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :lists, :extracted, :text
    add_column :lists, :resolved, :text
  end
end
