class AddDescriptionToUploadedList < ActiveRecord::Migration
  def change
    add_column :uploaded_lists, :description, :text
    add_index :uploaded_lists, :description
  end
end
