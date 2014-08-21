class AddCsPointsOfRecentLessonsToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :cs_points_of_recent_lessons, :float, :default => 0.0
  end
end
