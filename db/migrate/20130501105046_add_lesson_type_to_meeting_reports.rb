class AddLessonTypeToMeetingReports < ActiveRecord::Migration
  def change
    add_column :meeting_reports, :lesson_type, :string
    add_column :meeting_reports, :subjects, :string
  end
end
