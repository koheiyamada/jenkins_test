class AddPrefersOtherScheduleToMeegingMembers < ActiveRecord::Migration
  def change
    add_column :meeting_members, :prefers_other_schedule, :boolean, :default => false
  end
end
