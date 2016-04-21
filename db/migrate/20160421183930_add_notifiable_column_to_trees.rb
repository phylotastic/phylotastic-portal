class AddNotifiableColumnToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :notifiable, :boolean, default: true
  end
end
