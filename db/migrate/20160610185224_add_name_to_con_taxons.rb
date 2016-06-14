class AddNameToConTaxons < ActiveRecord::Migration
  def change
    add_column :con_taxons, :name, :string
    add_index :con_taxons, :name
  end
end
