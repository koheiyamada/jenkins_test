class RemoveLockedFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :locked
  end

  def down
    add_column :users, :locked, :boolean, :default => false
  end
end
