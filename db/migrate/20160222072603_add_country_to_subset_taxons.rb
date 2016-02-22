class AddCountryToSubsetTaxons < ActiveRecord::Migration
  def change
    add_reference :subset_taxons, :country, index: true, foreign_key: true
  end
end
