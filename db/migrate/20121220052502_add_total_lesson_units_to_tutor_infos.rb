class AddTotalLessonUnitsToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :total_lesson_units, :integer, :default => 0
  end
end
