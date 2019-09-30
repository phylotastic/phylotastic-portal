class AddStudiesToTree < ActiveRecord::Migration[5.1]
  def change
    add_column :trees, :studies, :text
  end
end
