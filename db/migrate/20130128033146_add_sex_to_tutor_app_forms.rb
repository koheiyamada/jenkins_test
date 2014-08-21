class AddSexToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :sex, :string, :default => "male"
    add_column :tutor_app_forms, :graduated, :boolean, :default => false
    add_column :tutor_app_forms, :grade, :integer
    add_column :tutor_app_forms, :graduate_college, :string
    add_column :tutor_app_forms, :major, :string
  end
end
