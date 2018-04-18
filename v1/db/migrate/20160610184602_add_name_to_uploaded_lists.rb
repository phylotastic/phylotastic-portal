class AddNameToUploadedLists < ActiveRecord::Migration
  def change
    add_column :uploaded_lists, :name, :string
    add_index :uploaded_lists, :name
  end
end
