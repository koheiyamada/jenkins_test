class CreateTutorDailyLessonSkips < ActiveRecord::Migration
  def change
    create_table :tutor_daily_lesson_skips do |t|
      t.references :tutor
      t.date :date
      t.integer :count, :default => 0

      t.timestamps
    end
    add_index :tutor_daily_lesson_skips, :tutor_id
  end
end
