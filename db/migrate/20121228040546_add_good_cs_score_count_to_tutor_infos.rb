class AddGoodCsScoreCountToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :good_cs_score_count, :integer, :default => 0
  end
end
