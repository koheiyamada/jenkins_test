class AddFeeToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :fee, :integer, :default => 0
  end
end
