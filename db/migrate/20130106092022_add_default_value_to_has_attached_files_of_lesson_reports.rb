class AddDefaultValueToHasAttachedFilesOfLessonReports < ActiveRecord::Migration
  def change
    change_column :lesson_reports, :has_attached_files, :boolean, :default => false
  end
end
