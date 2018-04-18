class CreatePhyloSources < ActiveRecord::Migration
  def change
    create_table :phylo_sources do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
