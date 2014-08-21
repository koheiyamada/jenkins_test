class AddStartDayToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :start_day, :date
  end
end
