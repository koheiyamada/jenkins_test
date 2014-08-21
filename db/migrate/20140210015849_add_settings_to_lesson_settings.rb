class AddSettingsToLessonSettings < ActiveRecord::Migration
  def change
    add_column :lesson_settings, :request_time_limit, :integer, default: 15
    add_column :lesson_settings, :max_units, :integer, default: 5
    add_column :lesson_settings, :max_units_of_basic_lesson, :integer, default: 5
    add_column :lesson_settings, :message_to_tutor, :string
  end
end
