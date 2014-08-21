class AddKanaToBsAppForms < ActiveRecord::Migration
  def change
    add_column :bs_app_forms, :first_name_kana, :string
    add_column :bs_app_forms, :last_name_kana, :string
    add_column :bs_app_forms, :high_school, :string
    add_column :bs_app_forms, :college, :string
    add_column :bs_app_forms, :department, :string
    add_column :bs_app_forms, :graduate_college, :string
    add_column :bs_app_forms, :major, :string
    add_column :bs_app_forms, :job_history, :string
    add_column :bs_app_forms, :use_document_camera, :string
    add_column :bs_app_forms, :interview_datetime_1, :datetime
    add_column :bs_app_forms, :interview_datetime_2, :datetime
    add_column :bs_app_forms, :interview_datetime_3, :datetime

  end
end
