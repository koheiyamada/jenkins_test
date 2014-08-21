class CreateLessonRequestRejections < ActiveRecord::Migration
  def change
    create_table :lesson_request_rejections do |t|
      t.references :lesson
      t.references :user
      t.string :reason

      t.timestamps
    end
    add_index :lesson_request_rejections, :lesson_id
    add_index :lesson_request_rejections, :user_id
  end
end
