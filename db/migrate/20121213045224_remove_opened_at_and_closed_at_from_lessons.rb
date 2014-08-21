class RemoveOpenedAtAndClosedAtFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :opened_at
    remove_column :lessons, :closed_at
  end

  def down
    add_column :lessons, :opened_at, :datetime
    add_column :lessons, :closed_at, :datetime
  end
end
