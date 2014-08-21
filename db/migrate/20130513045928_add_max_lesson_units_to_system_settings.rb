class AddMaxLessonUnitsToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :max_lesson_units, :integer, :default => 3
  end
end
