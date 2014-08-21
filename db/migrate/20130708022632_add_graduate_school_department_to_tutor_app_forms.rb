class AddGraduateSchoolDepartmentToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :graduate_college_department, :string
    add_column :tutor_app_forms, :student_number, :string
    add_column :tutor_app_forms, :driver_license_number, :string
    add_column :tutor_app_forms, :passport_number, :string
    add_column :tutor_app_forms, :pc_model_number, :string
    add_column :tutor_app_forms, :jyuku_history, :string
    add_column :tutor_app_forms, :favorite_books, :string, :limit => 1000
  end
end
