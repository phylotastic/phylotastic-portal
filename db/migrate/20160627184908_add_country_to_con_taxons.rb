class AddCountryToConTaxons < ActiveRecord::Migration
  def change
    add_reference :con_taxons, :country, index: true, foreign_key: true
  end
end
