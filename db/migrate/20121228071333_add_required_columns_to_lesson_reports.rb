class AddRequiredColumnsToLessonReports < ActiveRecord::Migration
  def change
    add_column :lesson_reports, :lesson_type, :string
    add_column :lesson_reports, :subject_id, :integer
    add_column :lesson_reports, :tutor_id, :integer
    add_column :lesson_reports, :lesson_content, :text
    add_column :lesson_reports, :has_attached_files, :boolean
    add_column :lesson_reports, :understanding, :text
    add_column :lesson_reports, :word_to_student, :text
    add_column :lesson_reports, :start_at, :datetime
    add_column :lesson_reports, :end_at, :datetime
    add_column :lesson_reports, :started_at, :datetime
    add_column :lesson_reports, :ended_at, :datetime
    add_column :lesson_reports, :note, :text
    add_column :lesson_reports, :homework_result, :string
  end
end
