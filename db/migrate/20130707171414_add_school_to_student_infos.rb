class AddSchoolToStudentInfos < ActiveRecord::Migration
  def change
    add_column :student_infos, :school, :string
  end
end
