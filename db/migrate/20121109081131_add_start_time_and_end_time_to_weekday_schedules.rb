class AddStartTimeAndEndTimeToWeekdaySchedules < ActiveRecord::Migration
  def change
    add_column :weekday_schedules, :start_time, :datetime
    add_column :weekday_schedules, :end_time, :datetime
    remove_column :weekday_schedules, :wday
    remove_column :weekday_schedules, :from
    remove_column :weekday_schedules, :to
  end
end
