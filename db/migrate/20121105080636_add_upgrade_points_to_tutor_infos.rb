class AddUpgradePointsToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :upgrade_points, :integer, :default => 0
  end
end
