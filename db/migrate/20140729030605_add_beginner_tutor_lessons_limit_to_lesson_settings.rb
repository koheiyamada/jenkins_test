class AddBeginnerTutorLessonsLimitToLessonSettings < ActiveRecord::Migration
  def change
    add_column :lesson_settings, :beginner_tutor_lessons_limit, :integer, default: 10, null: false
  end
end
