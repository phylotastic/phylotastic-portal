class CreateTrees < ActiveRecord::Migration[5.1]
  def change
    create_table :trees do |t|
      t.string :name
      t.text :species
      t.text :tree
      t.text :scaled_sdm
      t.boolean :branch_length
      t.references :user, foreign_key: true
      t.text :action_sequence
      t.boolean :list_from_service 
      t.integer :list_id
      
      t.timestamps
    end
  end
end
