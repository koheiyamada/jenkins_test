class AddAverageCsPointsToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :average_cs_points, :float, :default => 0.0
  end
end
