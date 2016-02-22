class AddCountryReferenceToSubsetTaxons < ActiveRecord::Migration
  def change
    add_column :subset_taxons, :country, :reference
    t.references :country, index: true, foreign_key: true
  end
end
