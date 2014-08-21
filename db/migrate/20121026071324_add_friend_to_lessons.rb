class AddFriendToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :is_group_lesson, :boolean, :default => false
    add_column :lessons, :friend_id, :integer
    add_index :lessons, :friend_id
  end
end
