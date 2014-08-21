class CreateMeetingSchedules < ActiveRecord::Migration
  def change
    create_table :meeting_schedules do |t|
      t.references :meeting
      t.datetime :datetime

      t.timestamps
    end
    add_index :meeting_schedules, :meeting_id
  end
end
