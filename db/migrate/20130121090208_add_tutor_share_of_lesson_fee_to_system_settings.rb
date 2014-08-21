class AddTutorShareOfLessonFeeToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :tutor_share_of_lesson_fee, :float, :default => 57.0
  end
end
