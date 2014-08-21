class AddMaxBasicLessonUnitsToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :max_basic_lesson_units, :integer, default: 5
  end
end
