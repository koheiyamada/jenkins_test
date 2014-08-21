class RemoveAddressIdFromUsers < ActiveRecord::Migration
  def up
    remove_index :users, :address_id
    remove_column :users, :address_id
  end

  def down
    add_column :users, :address_id, :integer
    add_index :users, :address_id
  end
end
