class AddStatusColumnsToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :status, :string
  end
end
