class CreateLessonSettings < ActiveRecord::Migration
  def change
    create_table :lesson_settings do |t|
      t.integer :tutor_entry_period_before_start_time, default: 10, null: false
      t.integer :tutor_entry_period_after_start_time, default: 0, null: false
      t.integer :student_entry_period_before_start_time, default: 5, null: false
      t.integer :student_entry_period_after_start_time, default: 45, null: false
      t.integer :dropout_limit, default: 10, null: false

      t.timestamps
    end
  end
end
