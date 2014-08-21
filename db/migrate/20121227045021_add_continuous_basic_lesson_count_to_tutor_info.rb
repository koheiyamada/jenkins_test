class AddContinuousBasicLessonCountToTutorInfo < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :continuous_basic_lesson_count, :integer, :default => 0
  end
end
