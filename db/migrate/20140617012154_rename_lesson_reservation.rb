class RenameLessonReservation < ActiveRecord::Migration
  def up
  	remove_column :users, :lesson_reservation
    add_column :users, :free_lesson_reservation, :integer, default: 0
  end
end