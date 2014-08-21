class AddDefaultMaxChargeToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :default_max_charge, :integer, :default => 50000
  end
end
