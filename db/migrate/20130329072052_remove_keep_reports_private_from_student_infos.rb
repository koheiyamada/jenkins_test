class RemoveKeepReportsPrivateFromStudentInfos < ActiveRecord::Migration
  def up
    remove_column :student_infos, :keep_reports_private
  end

  def down
    add_column :student_infos, :keep_reports_private, :boolean, :default => true
  end
end
