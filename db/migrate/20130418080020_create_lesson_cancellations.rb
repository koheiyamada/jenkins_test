class CreateLessonCancellations < ActiveRecord::Migration
  def change
    create_table :lesson_cancellations do |t|
      t.references :lesson_student

      t.timestamps
    end
    add_index :lesson_cancellations, :lesson_student_id
  end
end
