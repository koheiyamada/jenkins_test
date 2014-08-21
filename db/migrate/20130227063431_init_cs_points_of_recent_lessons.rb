class InitCsPointsOfRecentLessons < ActiveRecord::Migration
  def up
    Tutor.only_active.each do |tutor|
      if tutor.info
        tutor.info.update_attribute(:cs_points_of_recent_lessons, tutor.calculate_cs_points(Tutor.recent_lessons_count))
      end
    end
  end

  def down
  end
end
