class AddDefaultValuesToFreeLessonLimit < ActiveRecord::Migration
  def change
  	remove_column :users, :free_lesson_limit_number
    remove_column :users, :free_lesson_expiration_date
  	add_column :users, :free_lesson_limit_number, :integer, default: 3
    add_column :users, :free_lesson_expiration_date, :integer, default: 30
  end
end
