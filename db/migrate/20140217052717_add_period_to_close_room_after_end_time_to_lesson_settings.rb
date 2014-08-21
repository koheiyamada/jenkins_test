class AddPeriodToCloseRoomAfterEndTimeToLessonSettings < ActiveRecord::Migration
  def change
    add_column :lesson_settings, :period_to_close_room_after_end_time, :integer, default: 10, null: false
  end
end
