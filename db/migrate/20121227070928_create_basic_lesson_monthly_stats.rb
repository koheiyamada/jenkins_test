class CreateBasicLessonMonthlyStats < ActiveRecord::Migration
  def change
    create_table :basic_lesson_monthly_stats do |t|
      t.references :basic_lesson_info
      t.integer :year
      t.integer :month
      t.integer :tutor_schedule_change_count, :default => 0

      t.timestamps
    end
    add_index :basic_lesson_monthly_stats, :basic_lesson_info_id
    add_index :basic_lesson_monthly_stats, [:basic_lesson_info_id, :year, :month], :unique => true, :name => 'index_basic_lesson_monthly_stats_on_basic_lesson_id_year_month'
  end
end
