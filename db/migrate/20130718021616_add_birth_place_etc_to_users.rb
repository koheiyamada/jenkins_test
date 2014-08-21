class AddBirthPlaceEtcToUsers < ActiveRecord::Migration
  def change
    add_column :users, :birth_place, :string
    add_column :users, :driver_license_number, :string
    add_column :users, :passport_number, :string
    add_column :users, :pc_model_number, :string
    add_column :users, :has_web_camera, :string, :default => 'no'
  end
end
