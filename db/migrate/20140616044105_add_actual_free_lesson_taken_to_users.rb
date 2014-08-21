class AddActualFreeLessonTakenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :actual_free_lesson_taken, :integer, default: 0
  end
end
