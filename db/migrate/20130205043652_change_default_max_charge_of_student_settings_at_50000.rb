class ChangeDefaultMaxChargeOfStudentSettingsAt50000 < ActiveRecord::Migration
  def up
    change_column :student_settings, :max_charge, :integer, :default => 50000, :null => false
  end

  def down
    change_column :student_settings, :max_charge, :integer, :default => 10000, :null => false
  end
end
