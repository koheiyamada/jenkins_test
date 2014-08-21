class RemoveActualFreeLessonTakenFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :actual_free_lesson_taken
  end
end
