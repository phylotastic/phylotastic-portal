class CreateSelectionTaxons < ActiveRecord::Migration
  def change
    create_table :selection_taxons do |t|
      t.integer :nb_species
      t.string :criterion
      t.references :user, index: true, foreign_key: true
      
    end
  end
end
