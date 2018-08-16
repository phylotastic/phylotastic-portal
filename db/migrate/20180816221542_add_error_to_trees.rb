class AddErrorToTrees < ActiveRecord::Migration[5.1]
  def change
    add_column :trees, :error, :string
    add_column :trees, :possible_failure_record, :string
  end
end
