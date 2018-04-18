class AddPublicColumnToUploadedLists < ActiveRecord::Migration
  def change
    add_column :uploaded_lists, :public, :boolean, default: false
    add_column :uploaded_lists, :status, :boolean
  end
end
