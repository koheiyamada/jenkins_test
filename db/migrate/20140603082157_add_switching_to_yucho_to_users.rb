class AddSwitchingToYuchoToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :switching_to_yucho, :boolean
  end
end
