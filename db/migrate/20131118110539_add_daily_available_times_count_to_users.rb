class AddDailyAvailableTimesCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :daily_available_times_count, :integer, default: 0, null: false
  end
end
