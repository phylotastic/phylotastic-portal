class AddRepresentationColumnToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :representation, :text
  end
end
