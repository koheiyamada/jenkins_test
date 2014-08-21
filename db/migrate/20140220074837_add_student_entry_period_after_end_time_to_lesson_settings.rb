class AddStudentEntryPeriodAfterEndTimeToLessonSettings < ActiveRecord::Migration
  def change
    add_column :lesson_settings, :student_entry_period_after_end_time, :integer, default: 0, null: false
  end
end
