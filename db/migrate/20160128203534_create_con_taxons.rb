class CreateConTaxons < ActiveRecord::Migration
  def change
    create_table :con_taxons do |t|
      t.string :taxon
      t.string :name
      t.boolean :has_genome_in_ncbi
      t.integer :nb_species
      t.text :description
      
      t.references :user, index: true, foreign_key: true
            
      t.timestamps null: false
    end
    add_index :con_taxons, :name
    add_index :con_taxons, :description
  end
end
