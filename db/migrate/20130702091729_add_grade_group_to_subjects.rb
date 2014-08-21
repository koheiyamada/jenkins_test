class AddGradeGroupToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :grade_group_id, :integer
    add_index :subjects, :grade_group_id
  end
end
