class AddNoteToStudentInfos < ActiveRecord::Migration
  def change
    add_column :student_infos, :note, :string, :limit => 512
  end
end
