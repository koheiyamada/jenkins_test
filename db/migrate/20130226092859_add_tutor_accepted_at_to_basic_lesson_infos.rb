class AddTutorAcceptedAtToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :tutor_accepted_at, :datetime
  end
end
