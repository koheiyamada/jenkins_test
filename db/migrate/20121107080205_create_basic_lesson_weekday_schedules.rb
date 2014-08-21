class CreateBasicLessonWeekdaySchedules < ActiveRecord::Migration
  def change
    create_table :basic_lesson_weekday_schedules do |t|
      t.references :basic_lesson_info
      t.datetime :start_time
      t.datetime :end_time
      t.integer :units

      t.timestamps
    end
    add_index :basic_lesson_weekday_schedules, :basic_lesson_info_id
  end
end
