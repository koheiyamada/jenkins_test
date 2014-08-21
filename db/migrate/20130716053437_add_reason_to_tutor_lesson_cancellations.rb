class AddReasonToTutorLessonCancellations < ActiveRecord::Migration
  def change
    add_column :tutor_lesson_cancellations, :reason, :string
  end
end
