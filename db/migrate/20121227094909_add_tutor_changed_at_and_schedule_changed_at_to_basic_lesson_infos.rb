class AddTutorChangedAtAndScheduleChangedAtToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :tutor_changed_at, :datetime
    add_column :basic_lesson_infos, :schedule_changed_at, :datetime
  end
end
