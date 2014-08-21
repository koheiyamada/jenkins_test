class AddCancelledAtToLessonStudents < ActiveRecord::Migration
  def change
    add_column :lesson_students, :cancelled_at, :datetime
  end
end
