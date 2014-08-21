class AddPerformanceItemsToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :adsl, :boolean, :default => false
    add_column :tutor_app_forms, :os_id, :integer
    add_column :tutor_app_forms, :upload_speed, :float
    add_column :tutor_app_forms, :download_speed, :float
    add_column :tutor_app_forms, :windows_experience_index_score, :float
  end
end
