class RemoveFeeFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :fee
  end

  def down
    add_column :lessons, :fee, :integer, :default => 0
  end
end
