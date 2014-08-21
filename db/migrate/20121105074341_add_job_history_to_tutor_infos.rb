class AddJobHistoryToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :job_history, :string, :length => 1000
  end
end
