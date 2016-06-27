class CreateSubsetTaxons < ActiveRecord::Migration
  def change
    create_table :subset_taxons do |t|
      t.boolean :has_genome_in_ncbi
      t.references :user, index: true, foreign_key: true
    end
  end
end
