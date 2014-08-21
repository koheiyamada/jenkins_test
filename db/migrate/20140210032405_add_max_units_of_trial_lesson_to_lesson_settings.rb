class AddMaxUnitsOfTrialLessonToLessonSettings < ActiveRecord::Migration
  def change
    add_column :lesson_settings, :max_units_of_trial_lesson, :integer, default: 29
    add_column :lesson_settings, :duration_per_unit, :integer, default: 45
  end
end
