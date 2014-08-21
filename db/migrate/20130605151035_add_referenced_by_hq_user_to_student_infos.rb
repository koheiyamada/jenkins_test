class AddReferencedByHqUserToStudentInfos < ActiveRecord::Migration
  def change
    add_column :student_infos, :referenced_by_hq_user, :boolean, :default => false
  end
end
