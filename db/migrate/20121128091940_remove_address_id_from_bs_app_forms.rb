class RemoveAddressIdFromBsAppForms < ActiveRecord::Migration
  def up
    remove_index :bs_app_forms, :address_id
    remove_column :bs_app_forms, :address_id
  end

  def down
    add_column :bs_app_forms, :address_id, :integer
    add_index :bs_app_forms, :address_id
  end
end
