class AddWeekdaySchedulesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :weekday_schedules_count, :integer, :null => false, :default => 0

    Tutor.all.each do |tutor|
      Tutor.reset_counters tutor.id, :weekday_schedules
    end
  end
end
