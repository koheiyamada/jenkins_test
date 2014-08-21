class RemoveWdaysStartTimeAndEndTimeFromBasicLessonInfos < ActiveRecord::Migration
  def up
    remove_column :basic_lesson_infos, :wdays
    remove_column :basic_lesson_infos, :start_time
    remove_column :basic_lesson_infos, :end_time
    remove_column :basic_lesson_infos, :units
  end

  def down
    add_column :basic_lesson_infos, :wdays, :text
    add_column :basic_lesson_infos, :start_time, :time
    add_column :basic_lesson_infos, :end_time, :time
    add_column :basic_lesson_infos, :units, :integer
  end
end
