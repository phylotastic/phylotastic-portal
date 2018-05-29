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
      t.list_from_service :boolean
      t.list_id :integer
      
      t.timestamps
    end
  end
end
