class CreateBasicLessonPossibleStudents < ActiveRecord::Migration
  def change
    create_table :basic_lesson_possible_students do |t|
      t.references :basic_lesson_info
      t.references :student

      t.timestamps
    end
    add_index :basic_lesson_possible_students, :basic_lesson_info_id
    add_index :basic_lesson_possible_students, :student_id
  end
end
