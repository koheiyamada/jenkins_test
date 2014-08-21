class AddTimeStampsToLessonStudents < ActiveRecord::Migration
  def change
    add_column :lesson_students, :created_at, :datetime, :null => false
    add_column :lesson_students, :updated_at, :datetime, :null => false
  end
end
