class CreateOnplFiles < ActiveRecord::Migration
  def change
    create_table :onpl_files do |t|
      t.references :user, index: true, foreign_key: true
      t.string :name
      t.text :description
      
      t.timestamps null: false
    end

    add_index :onpl_files, :name
    add_index :onpl_files, :description
  end
end
