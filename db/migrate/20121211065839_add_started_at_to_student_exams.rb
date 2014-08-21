class AddStartedAtToStudentExams < ActiveRecord::Migration
  def change
    add_column :student_exams, :started_at, :datetime
  end
end
