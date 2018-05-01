class CreateTaxonomies < ActiveRecord::Migration[5.1]
  def change
    create_table :taxonomies do |t|
      t.references :user, foreign_key: true, index: true
      t.string :taxon
      t.boolean :location
      t.references :country, foreign_key: true
      t.boolean :has_genome_in_ncbi
      t.boolean :quantity
      t.integer :number_species

      t.timestamps
    end
  end
end
