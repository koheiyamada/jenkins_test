class CreateBasicLessonStudents < ActiveRecord::Migration
  def change
    create_table :basic_lesson_students do |t|
      t.references :basic_lesson_info
      t.references :student
    end
    add_index :basic_lesson_students, :basic_lesson_info_id
    add_index :basic_lesson_students, :student_id
  end
end
