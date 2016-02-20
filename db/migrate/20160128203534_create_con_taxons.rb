class CreateConTaxons < ActiveRecord::Migration
  def change
    create_table :con_taxons do |t|
      t.string :name
      t.references :user, index: true, foreign_key: true
      t.actable
      
      t.timestamps null: false
    end
  end
end
