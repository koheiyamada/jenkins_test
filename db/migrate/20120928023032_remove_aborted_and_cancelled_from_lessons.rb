class RemoveAbortedAndCancelledFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :aborted
    remove_column :lessons, :cancelled
  end

  def down
    add_column :lessons, :aborted, :boolean, :default => false
    add_column :lessons, :cancelled, :boolean, :default => false
  end
end
