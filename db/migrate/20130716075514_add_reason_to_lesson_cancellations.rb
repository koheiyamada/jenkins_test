class AddReasonToLessonCancellations < ActiveRecord::Migration
  def change
    add_column :lesson_cancellations, :reason, :string
  end
end
