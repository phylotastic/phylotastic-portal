class AddUserIdToRawExtractions < ActiveRecord::Migration
  def change
    add_column :raw_extractions, :user_id, :integer
  end
end
