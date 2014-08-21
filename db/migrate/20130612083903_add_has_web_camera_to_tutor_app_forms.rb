class AddHasWebCameraToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :has_web_camera, :boolean, :default => true
  end
end
