class AddScalingRepresentationToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :scaled_representation, :text
  end
end
