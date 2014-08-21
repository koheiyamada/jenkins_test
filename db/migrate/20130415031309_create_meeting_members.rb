class CreateMeetingMembers < ActiveRecord::Migration
  def change
    create_table :meeting_members do |t|
      t.references :meeting
      t.references :user
      t.references :preferred_schedule

      t.timestamps
    end
    add_index :meeting_members, :meeting_id
    add_index :meeting_members, :user_id
    add_index :meeting_members, :preferred_schedule_id
  end
end
