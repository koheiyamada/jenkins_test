class AddDelayedAndNotStartedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :delayed, :boolean, :default => false
    add_column :lessons, :not_started, :boolean, :default => false
  end
end
