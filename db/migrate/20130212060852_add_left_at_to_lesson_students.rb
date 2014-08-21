class AddLeftAtToLessonStudents < ActiveRecord::Migration
  def change
    add_column :lesson_students, :left_at, :datetime
  end
end
