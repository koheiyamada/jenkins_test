class CreateLessonDropouts < ActiveRecord::Migration
  def change
    create_table :lesson_dropouts do |t|
      t.references :lesson_student

      t.timestamps
    end
    add_index :lesson_dropouts, :lesson_student_id
  end
end
