class AddLessonRequestTimeLimitToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :lesson_request_time_limit, :integer, :default => 15
  end
end
