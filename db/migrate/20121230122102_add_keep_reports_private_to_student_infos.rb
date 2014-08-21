class AddKeepReportsPrivateToStudentInfos < ActiveRecord::Migration
  def change
    add_column :student_infos, :keep_reports_private, :boolean, :default => true
  end
end
