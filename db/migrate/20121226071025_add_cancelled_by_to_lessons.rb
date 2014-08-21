class AddCancelledByToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :cancelled_by, :integer
  end
end
