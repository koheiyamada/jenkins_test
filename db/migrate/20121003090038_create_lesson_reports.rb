class CreateLessonReports < ActiveRecord::Migration
  def change
    create_table :lesson_reports do |t|
      t.references :lesson
      t.references :author
      t.references :student
      t.text :content

      t.timestamps
    end
    add_index :lesson_reports, :lesson_id
    add_index :lesson_reports, :author_id
    add_index :lesson_reports, :student_id
  end
end
