class CreateTutorStudents < ActiveRecord::Migration
  def change
    create_table :tutor_students do |t|
      t.references :tutor
      t.references :student
      t.boolean :lesson_report, :default => true

      t.timestamps
    end
    add_index :tutor_students, :tutor_id
    add_index :tutor_students, :student_id
  end
end
