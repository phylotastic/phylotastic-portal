class AddLidColumnToUploadedList < ActiveRecord::Migration
  def change
    add_column :uploaded_lists, :lid, :integer
    add_index :uploaded_lists, :lid
  end
end
