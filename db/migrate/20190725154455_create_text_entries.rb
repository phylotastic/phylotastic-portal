class CreateTextEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :text_entries do |t|
      t.text :corpus
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
