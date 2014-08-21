class AddJournalizedFreeLessonCountToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :journalized_free_lesson_count, :integer, default: 0
  end
end
