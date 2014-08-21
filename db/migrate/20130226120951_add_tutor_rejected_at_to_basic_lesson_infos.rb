class AddTutorRejectedAtToBasicLessonInfos < ActiveRecord::Migration
  def change
    add_column :basic_lesson_infos, :tutor_rejected_at, :datetime
  end
end
