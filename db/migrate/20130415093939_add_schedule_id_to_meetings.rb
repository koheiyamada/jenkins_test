class AddScheduleIdToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :schedule_id, :integer
  end
end
