class AddSomeFieldsToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :student_number, :string
    add_column :tutor_infos, :driver_license_number, :string
    add_column :tutor_infos, :passport_number, :string
    add_column :tutor_infos, :pc_model_number, :string
    add_column :tutor_infos, :jyuku_history, :string
  end
end
