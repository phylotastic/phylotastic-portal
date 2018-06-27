class AddPopulationToTaxonomy < ActiveRecord::Migration[5.1]
  def change
    add_column :taxonomies, :popularity, :boolean
    add_column :taxonomies, :number_popularity, :integer
  end
end
