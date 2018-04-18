class AddDescriptionColumnsToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :description, :text
  end
end
