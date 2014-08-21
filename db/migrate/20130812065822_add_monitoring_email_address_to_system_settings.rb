class AddMonitoringEmailAddressToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :monitoring_email_address, :string
  end
end
