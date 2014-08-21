class AddTextbookUsageToLessonReports < ActiveRecord::Migration
  def change
    add_column :lesson_reports, :textbook_usage, :string
    add_column :lesson_reports, :homework, :string
  end
end
