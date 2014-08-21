class RenameTrialModeToFreeMode < ActiveRecord::Migration
  def up
  	remove_column :system_settings, :trial_mode
  	remove_column :system_settings, :trial_lesson_limit_number
    remove_column :system_settings, :trial_lesson_expiration_date
    add_column :system_settings, :free_mode, :boolean, default: false
    add_column :system_settings, :free_lesson_limit_number, :integer, default: 3
    add_column :system_settings, :free_lesson_expiration_date, :integer, default: 30
  end
end
