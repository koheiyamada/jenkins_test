class AddBirthPlaceToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :birth_place, :string
    add_column :bs_app_forms, :driver_license_number, :string
    add_column :bs_app_forms, :passport_number, :string
    add_column :bs_app_forms, :pc_model_number, :string
    add_column :bs_app_forms, :has_web_camera, :string, :default => 'no'
  end
end
