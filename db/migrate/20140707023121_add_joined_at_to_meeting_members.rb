class AddJoinedAtToMeetingMembers < ActiveRecord::Migration
  def change
    add_column :meeting_members, :joined_at, :datetime
  end
end
