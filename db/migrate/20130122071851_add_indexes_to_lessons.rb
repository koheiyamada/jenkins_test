class AddIndexesToLessons < ActiveRecord::Migration
  def change
    add_index :lessons, :start_time
    add_index :lessons, :end_time
    add_index :lessons, :show_on_calendar
    add_index :lessons, :schedule_fixed
  end
end
