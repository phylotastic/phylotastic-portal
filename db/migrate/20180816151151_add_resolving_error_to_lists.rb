class AddResolvingErrorToLists < ActiveRecord::Migration[5.1]
  def change
    add_column :lists, :resolving_error, :string
    add_column :lists, :possible_failure_record, :integer
  end
end
