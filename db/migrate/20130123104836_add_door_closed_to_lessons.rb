class AddDoorClosedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :door_closed, :boolean, :default => false
  end
end
