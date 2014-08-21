class AddMeetingVideoBandwidthToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :meeting_video_bandwidth, :integer, :default => (16384 * 3)
    add_column :system_settings, :meeting_video_fps, :integer, :default => 10
    add_column :system_settings, :meeting_video_quality, :integer, :default => 90
  end
end
