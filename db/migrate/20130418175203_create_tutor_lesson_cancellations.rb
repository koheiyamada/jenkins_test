class CreateTutorLessonCancellations < ActiveRecord::Migration
  def change
    create_table :tutor_lesson_cancellations do |t|
      t.references :lesson

      t.timestamps
    end
    add_index :tutor_lesson_cancellations, :lesson_id
  end
end
