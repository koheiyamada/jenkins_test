class CreateLessonExtensionRequests < ActiveRecord::Migration
  def change
    create_table :lesson_extension_requests do |t|
      t.references :lesson_student

      t.timestamps
    end
    add_index :lesson_extension_requests, :lesson_student_id
  end
end
