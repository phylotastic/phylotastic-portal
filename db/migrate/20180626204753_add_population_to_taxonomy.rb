class AddPopulationToTaxonomy < ActiveRecord::Migration[5.1]
  def change
    add_column :taxonomies, :population, :boolean
    add_column :taxonomies, :number_population, :integer
  end
end
