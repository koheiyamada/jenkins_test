class RemoveOldColumnsFromSystemSettings < ActiveRecord::Migration
  def up
    remove_column :system_settings, :lesson_request_time_limit
    remove_column :system_settings, :max_lesson_units
    remove_column :system_settings, :max_basic_lesson_units
    remove_column :system_settings, :slogan_for_tutors
  end

  def down
    add_column :system_settings, :max_lesson_units, :integer, :default => 3
    add_column :system_settings, :lesson_request_time_limit, :integer, :default => 15
    add_column :system_settings, :max_basic_lesson_units, :integer, :default => 5
    add_column :system_settings, :slogan_for_tutors, :string
  end
end
