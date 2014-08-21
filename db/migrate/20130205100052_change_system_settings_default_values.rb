class ChangeSystemSettingsDefaultValues < ActiveRecord::Migration
  def up
    change_column :system_settings, :bs_share_of_lesson_sales, :float, :default => 0.2
    change_column :system_settings, :tutor_share_of_lesson_fee, :float, :default => 0.57
  end

  def down
    change_column :system_settings, :bs_share_of_lesson_sales, :float, :default => 20.0
    change_column :system_settings, :tutor_share_of_lesson_fee, :float, :default => 57.0
  end
end
