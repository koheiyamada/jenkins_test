class AddFacultyToTutorAppForms < ActiveRecord::Migration
  def change
    add_column :tutor_app_forms, :faculty, :string
  end
end
