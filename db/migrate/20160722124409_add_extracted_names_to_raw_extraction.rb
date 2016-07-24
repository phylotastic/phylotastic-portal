class AddExtractedNamesToRawExtraction < ActiveRecord::Migration
  def change
    add_column :raw_extractions, :extracted_names, :text
  end
end
