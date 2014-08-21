class AddTutorAttendedAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :tutor_attended_at, :datetime
  end
end
