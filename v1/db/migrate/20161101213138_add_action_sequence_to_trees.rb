class AddActionSequenceToTrees < ActiveRecord::Migration
  def change
    add_column :trees, :action_sequence, :string
  end
end
