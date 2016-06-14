class ChangeNameToTaxonInConTaxon < ActiveRecord::Migration
  def change
    rename_column :con_taxons, :name, :taxon
  end
end
