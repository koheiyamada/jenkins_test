class AddCsPointsToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :cs_points, :integer, :default => 0
  end
end
