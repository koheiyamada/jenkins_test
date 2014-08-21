class RemoveTimeDoorOpenBeforeLessonStartFromSystemSettings < ActiveRecord::Migration
  def up
    remove_column :system_settings, :time_door_open_before_lesson_start
  end

  def down
    add_column :system_settings, :time_door_open_before_lesson_start, :integer, default: 10
  end
end
