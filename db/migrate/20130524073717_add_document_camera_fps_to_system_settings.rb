class AddDocumentCameraFpsToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :document_camera_fps, :integer, :default => 2
  end
end
