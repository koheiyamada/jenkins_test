class AddCancelledAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :cancelled_at, :datetime
  end
end
