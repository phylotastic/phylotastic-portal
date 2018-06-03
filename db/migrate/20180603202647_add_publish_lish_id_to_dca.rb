class AddPublishLishIdToDca < ActiveRecord::Migration[5.1]
  def change
    add_column :dcas, :publish_list_id, :integer
  end
end
