class AddYuchoAccountApplicationIdToTempYuchoAccounts < ActiveRecord::Migration
  def change
  	add_column :temp_yucho_accounts, :yucho_account_application_id, :integer
  end
end
