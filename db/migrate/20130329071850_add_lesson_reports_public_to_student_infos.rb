class AddLessonReportsPublicToStudentInfos < ActiveRecord::Migration
  def change
    add_column :student_infos, :lesson_reports_public, :boolean, :default => false
  end
end
