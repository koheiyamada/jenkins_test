class AddMeetingCameraResolusionToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :meeting_camera_width, :integer, default: 640
    add_column :system_settings, :meeting_camera_height, :integer, default: 480
  end
end
