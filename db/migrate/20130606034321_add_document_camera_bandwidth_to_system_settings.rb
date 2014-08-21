class AddDocumentCameraBandwidthToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :document_camera_bandwidth, :integer, :default => 0
    add_column :system_settings, :document_camera_quality, :integer, :default => 90
  end
end
