class AddTempYuchoAccountIdToYuchoAccountApplication < ActiveRecord::Migration
  def change
  	remove_column :temp_yucho_accounts, :yucho_account_application_id
  	add_column :membership_applications, :temp_yucho_account_id, :integer
  end
end
