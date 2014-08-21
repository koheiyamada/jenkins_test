class AddShowOnCalendarAndScheduleFixedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :show_on_calendar, :boolean, :default => false
    add_column :lessons, :schedule_fixed, :boolean, :default => false

    Lesson.all.each do |lesson|
      if lesson.new?
        lesson.update_attribute(:schedule_fixed, true)
      end
      if lesson.accepted? || lesson.open? || lesson.done? || lesson.aborted?
        lesson.update_attribute(:schedule_fixed, true)
        lesson.update_attribute(:show_on_calendar, true)
      end
    end
  end
end
