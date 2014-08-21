class AddTimeDoorOpenBeforeLessonStartToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :time_door_open_before_lesson_start, :integer, default: 10
  end
end
