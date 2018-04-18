class AddColumnReasonToUploadedList < ActiveRecord::Migration
  def change
    add_column :uploaded_lists, :reason, :string
  end
end
