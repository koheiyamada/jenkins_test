class RemoveAddressIdsFromTutorInfos < ActiveRecord::Migration
  def up
    remove_index :tutor_infos, :current_address_id
    remove_column :tutor_infos, :current_address_id

    remove_index :tutor_infos, :hometown_address_id
    remove_column :tutor_infos, :hometown_address_id
  end

  def down
    add_column :tutor_infos, :current_address_id, :integer
    add_index :tutor_infos, :current_address_id

    add_column :tutor_infos, :hometown_address_id, :integer
    add_index :tutor_infos, :hometown_address_id
  end
end
