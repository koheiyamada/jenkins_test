class AddLessonSkipCountToTutorInfos < ActiveRecord::Migration
  def change
    add_column :tutor_infos, :lesson_skip_count, :integer, :default => 0
  end
end
