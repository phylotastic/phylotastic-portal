class CreateRawExtractions < ActiveRecord::Migration
  def change
    create_table :raw_extractions do |t|
      t.text :species
      t.references :contributable, polymorphic: true, index: {:name => "index_raw_extraction_for_contributable"}
      
      t.timestamps null: false
    end
  end
end
