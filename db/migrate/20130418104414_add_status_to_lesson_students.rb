class AddStatusToLessonStudents < ActiveRecord::Migration
  def change
    add_column :lesson_students, :status, :string, :default => 'active'
  end
end
