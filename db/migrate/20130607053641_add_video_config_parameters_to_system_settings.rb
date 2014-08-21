class AddVideoConfigParametersToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :video_fps, :integer, :default => 10
    add_column :system_settings, :video_bandwidth, :integer, :default => 16384
    add_column :system_settings, :video_quality, :integer, :default => 90
  end
end
