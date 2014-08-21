class RemoveTempYuchoAccountIdFromYuchoAccountApplication < ActiveRecord::Migration
  def up
  	remove_column :membership_applications, :temp_yucho_account_id
  end
end
