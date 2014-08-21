class AddTutorEnteredAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :tutor_entered_at, :datetime
  end
end
