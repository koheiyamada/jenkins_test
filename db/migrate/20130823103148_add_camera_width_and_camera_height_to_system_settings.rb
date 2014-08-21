class AddCameraWidthAndCameraHeightToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :camera_width, :integer, :default => 160
    add_column :system_settings, :camera_height, :integer, :default => 120
  end
end
