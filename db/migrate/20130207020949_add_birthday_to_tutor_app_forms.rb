class AddBirthdayToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :birthday, :date
    add_column :tutor_app_forms, :grades_and_subjects, :string
    add_column :tutor_app_forms, :pc_spec, :string
    add_column :tutor_app_forms, :line_speed, :string
    add_column :tutor_app_forms, :use_document_camera, :boolean
    add_column :tutor_app_forms, :reference, :string
    add_column :tutor_app_forms, :special_tutor, :boolean
    add_column :tutor_app_forms, :special_tutor_wage, :integer
    add_column :tutor_app_forms, :interview_datetime_1, :datetime
    add_column :tutor_app_forms, :interview_datetime_2, :datetime
    add_column :tutor_app_forms, :interview_datetime_3, :datetime
  end
end
