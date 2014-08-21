class RemoveLessonExtensionApplications < ActiveRecord::Migration
  def up
    if table_exists? :lesson_extension_applications
      drop_table :lesson_extension_applications
    end
  end

  def down
    unless table_exists? :lesson_extension_applications
      create_table "lesson_extension_applications", :force => true do |t|
        t.integer  "lesson_id"
        t.integer  "student_id"
        t.datetime "created_at", :null => false
        t.datetime "updated_at", :null => false
      end

      add_index "lesson_extension_applications", ["lesson_id"], :name => "index_lesson_extension_applications_on_lesson_id"
      add_index "lesson_extension_applications", ["student_id"], :name => "index_lesson_extension_applications_on_student_id"
    end
  end
end
