class AddAccessTokenColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :access_token, :string
    add_column :users, :expires_at, :integer
  end
end
