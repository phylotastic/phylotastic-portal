class CreateCloningRelationships < ActiveRecord::Migration
  def change
    create_table :cloning_relationships do |t|
      t.integer :parent
      t.integer :child

      t.timestamps null: false
    end
    
    add_index :cloning_relationships, :parent
    add_index :cloning_relationships, :child
  end
end
