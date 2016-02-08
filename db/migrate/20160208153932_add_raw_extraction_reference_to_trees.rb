class AddRawExtractionReferenceToTrees < ActiveRecord::Migration
  def change
    add_reference :trees, :raw_extraction, index: true, foreign_key: true
  end
end
