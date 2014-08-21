class CreateSystemSettings < ActiveRecord::Migration
  def change
    create_table :system_settings do |t|
      t.integer :entry_fee
      t.integer :message_storage_period

      t.timestamps
    end

#エラーの原因？
=begin
    SystemSettings.create! do |settings|
      settings.entry_fee = 20000
      settings.message_storage_period = 30 # days
    end
=end

  end
end
