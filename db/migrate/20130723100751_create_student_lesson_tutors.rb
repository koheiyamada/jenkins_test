class CreateStudentLessonTutors < ActiveRecord::Migration
  def change
    create_table :student_lesson_tutors do |t|
      t.references :student
      t.references :tutor

      t.timestamps
    end
    add_index :student_lesson_tutors, :student_id
    add_index :student_lesson_tutors, :tutor_id

    puts <<-END
#############################################################
#
# RUN script/student/reset_connections_with_tutors.rb
#
#############################################################
    END
  end
end
