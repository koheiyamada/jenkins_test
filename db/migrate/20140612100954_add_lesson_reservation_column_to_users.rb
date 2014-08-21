class AddLessonReservationColumnToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :lesson_reservation, :integer, default: 0
  end
end
