class CreateCns < ActiveRecord::Migration[5.1]
  def change
    create_table :cns do |t|
      t.references :user, foreign_key: true, index: true
      t.boolean :multiple_match, :default => false

      t.timestamps
    end
  end
end
