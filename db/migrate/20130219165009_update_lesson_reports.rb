class UpdateLessonReports < ActiveRecord::Migration
  def up
    LessonReport.all.each do |lesson_report|
      lesson_report.save
    end
  end

  def down
  end
end
