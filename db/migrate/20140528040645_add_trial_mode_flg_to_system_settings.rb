class AddTrialModeFlgToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :trial_mode, :boolean, default: false
    add_column :system_settings, :trial_lesson_limit_number, :integer, default: 3
    add_column :system_settings, :trial_lesson_expiration_date, :integer, default: 30
  end
end