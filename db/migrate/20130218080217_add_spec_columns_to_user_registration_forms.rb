class AddSpecColumnsToUserRegistrationForms < ActiveRecord::Migration
  def change
    add_column :user_registration_forms, :upload_speed, :float
    add_column :user_registration_forms, :download_speed, :float
    add_column :user_registration_forms, :os_id, :integer
    add_column :user_registration_forms, :windows_experience_index_score, :float
  end
end
