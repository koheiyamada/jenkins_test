class AddIndexToTutorDailyAvailableTimes < ActiveRecord::Migration
  def change
    add_index :tutor_daily_available_times, :start_at
    add_index :tutor_daily_available_times, :end_at
  end
end
