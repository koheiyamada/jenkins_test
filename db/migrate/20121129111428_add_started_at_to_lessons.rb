class AddStartedAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :started_at, :datetime
  end
end
