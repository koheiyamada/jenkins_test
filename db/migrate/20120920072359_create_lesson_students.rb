class CreateLessonStudents < ActiveRecord::Migration
  def change
    create_table :lesson_students do |t|
      t.references :lesson
      t.references :student
    end
    add_index :lesson_students, :lesson_id
    add_index :lesson_students, :student_id
  end
end
