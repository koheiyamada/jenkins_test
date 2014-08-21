class AddEnteredAtToLessonStudents < ActiveRecord::Migration
  def change
    add_column :lesson_students, :entered_at, :datetime
  end
end
