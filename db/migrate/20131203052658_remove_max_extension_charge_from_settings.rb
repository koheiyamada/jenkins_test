class RemoveMaxExtensionChargeFromSettings < ActiveRecord::Migration
  def up
    remove_column :student_settings, :max_option_charge
    remove_column :student_settings, :max_extension_charge
  end

  def down
    add_column :student_settings, :max_extension_charge, :default => 0, :null => false
    add_column :student_settings, :max_option_charge, :default => 0, :null => false
  end
end
