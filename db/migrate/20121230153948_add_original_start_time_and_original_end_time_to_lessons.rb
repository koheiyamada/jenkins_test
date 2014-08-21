class AddOriginalStartTimeAndOriginalEndTimeToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :original_start_time, :datetime
    add_column :lessons, :original_end_time, :datetime
  end
end
