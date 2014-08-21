class CreateGradeGroupsSubjects < ActiveRecord::Migration
  def change
    create_table :grade_groups_subjects, :force => true do |t|
      t.integer :grade_group_id
      t.integer :subject_id
    end

    add_index :grade_groups_subjects, :grade_group_id
    add_index :grade_groups_subjects, :subject_id
  end
end
