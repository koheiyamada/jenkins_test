class AddBsShareOfLessonSalesToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :bs_share_of_lesson_sales, :float, :default => 20
  end
end
