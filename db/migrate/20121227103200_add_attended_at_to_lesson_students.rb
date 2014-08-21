class AddAttendedAtToLessonStudents < ActiveRecord::Migration
  def change
    add_column :lesson_students, :attended_at, :datetime
  end
end
