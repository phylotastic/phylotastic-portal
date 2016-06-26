class AddDescriptionToUploadedList < ActiveRecord::Migration
  def change
    add_column :uploaded_lists, :description, :text
  end
end
