class AddHobbyToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :hobby, :string
  end
end
