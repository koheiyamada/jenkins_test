class AddSubjectLevelIdToTeachingSubjects < ActiveRecord::Migration
  def change
    add_column :teaching_subjects, :subject_level_id, :integer
    add_index :teaching_subjects, :subject_level_id
  end
end
