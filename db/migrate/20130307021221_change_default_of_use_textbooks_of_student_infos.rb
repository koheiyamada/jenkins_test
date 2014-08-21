class ChangeDefaultOfUseTextbooksOfStudentInfos < ActiveRecord::Migration
  def up
    change_column :student_infos, :use_textbooks, :boolean, :default => true
  end

  def down
    change_column :student_infos, :use_textbooks, :boolean
  end
end
