class AddFacultyToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :faculty, :string
  end
end
