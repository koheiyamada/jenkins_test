class AddLessonDelayLimitToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :lesson_delay_limit, :integer, :default => 10
  end
end
