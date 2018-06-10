class CreateFailures < ActiveRecord::Migration[5.1]
  def change
    create_table :failures do |t|
      t.string :url
      t.text :data
      t.text :response

      t.timestamps
    end
  end
end
