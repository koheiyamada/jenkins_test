class RemoveAddressIdFromUserInfos < ActiveRecord::Migration
  def up
    remove_index :user_infos, :address_id
    remove_column :user_infos, :address_id
  end

  def down
    add_column :user_infos, :address_id, :integer
    add_column :user_infos, :address_id
  end
end
