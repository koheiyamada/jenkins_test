class AddDocumentCameraWidthAndHeightToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :document_camera_width, :integer, :default => 720
    add_column :system_settings, :document_camera_height, :integer, :default => 540
  end
end
