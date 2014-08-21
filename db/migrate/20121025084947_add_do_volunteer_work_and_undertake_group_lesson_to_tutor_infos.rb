class AddDoVolunteerWorkAndUndertakeGroupLessonToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :do_volunteer_work, :boolean, :default => false
    add_column :tutor_infos, :undertake_group_lesson, :boolean, :default => false
  end
end
