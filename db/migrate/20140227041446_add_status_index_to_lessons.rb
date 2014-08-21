class AddStatusIndexToLessons < ActiveRecord::Migration
  def change
    add_index :lessons, :status
  end
end
