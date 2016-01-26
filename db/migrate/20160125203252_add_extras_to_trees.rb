class AddExtrasToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :branch_length, :boolean
    add_column :trees, :images_from_EOL, :boolean
  end
end
