class AddApiKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :integer, default: 1
  end
end
