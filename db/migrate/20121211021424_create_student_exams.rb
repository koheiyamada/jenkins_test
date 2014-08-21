class CreateStudentExams < ActiveRecord::Migration
  def change
    create_table :student_exams do |t|
      t.references :student
      t.references :exam

      t.timestamps
    end
    add_index :student_exams, :student_id
    add_index :student_exams, :exam_id
  end
end
