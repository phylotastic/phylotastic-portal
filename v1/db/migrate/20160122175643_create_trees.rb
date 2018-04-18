class CreateTrees < ActiveRecord::Migration
  def change
    create_table :trees do |t|
      t.boolean :public, default: false
      t.text :chosen_species
      t.references :user, index: true, foreign_key: true
      
      t.timestamps
    end
    
    add_index :trees, [:user_id, :created_at]
  end
end
