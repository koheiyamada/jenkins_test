class AddGraduateSchoolAndElseToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :graduated, :boolean, :default => false
    add_column :tutor_infos, :graduate_college, :string
    add_column :tutor_infos, :grade, :integer
    add_column :tutor_infos, :major, :string
  end
end
