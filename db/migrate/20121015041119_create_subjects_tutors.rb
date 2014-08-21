class CreateSubjectsTutors < ActiveRecord::Migration
  def change
    create_table :subjects_tutors do |t|
      t.references :subject
      t.references :tutor
    end
    add_index :subjects_tutors, :subject_id
    add_index :subjects_tutors, :tutor_id
  end
end
