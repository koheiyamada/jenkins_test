class AddEndedAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :ended_at, :datetime
  end
end
