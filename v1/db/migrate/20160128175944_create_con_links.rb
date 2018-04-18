class CreateConLinks < ActiveRecord::Migration
  def change
    create_table :con_links do |t|
      t.string :uri
      t.references :user, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
