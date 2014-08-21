class ChangeCsPointsOfTutorInfosFromIntegerToFloat < ActiveRecord::Migration
  def up
    change_column :tutor_infos, :cs_points, :float, :default => 0
  end

  def down
    change_column :tutor_infos, :cs_points, :integer, :default => 0
  end
end
