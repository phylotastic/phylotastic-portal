class AddTempIdToRawExtractions < ActiveRecord::Migration
  def change
    add_column :raw_extractions, :temp_id, :string
    add_index :raw_extractions, :temp_id
  end
end
