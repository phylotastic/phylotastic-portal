class CreateConFiles < ActiveRecord::Migration
  def change
    create_table :con_files do |t|
      t.references :user, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
