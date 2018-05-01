class CreateDcas < ActiveRecord::Migration[5.1]
  def change
    create_table :dcas do |t|
      t.references :user, foreign_key: true, index: true

      t.timestamps
    end
  end
end
