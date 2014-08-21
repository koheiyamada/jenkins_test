class CreateTeachingSubjects < ActiveRecord::Migration
  def change
    create_table :teaching_subjects do |t|
      t.references :tutor
      t.references :grade_group
      t.references :subject
      t.integer :level, :default => 0

      t.timestamps
    end
    add_index :teaching_subjects, :tutor_id
    add_index :teaching_subjects, :grade_group_id
    add_index :teaching_subjects, :subject_id
  end
end
