class CreateLists < ActiveRecord::Migration[5.1]
  def change
    create_table :lists do |t|
      t.string     :name
      t.text       :description
      t.references :resource, polymorphic: true, index: true
      t.text       :species_names
      
      t.timestamps
    end
  end
end
