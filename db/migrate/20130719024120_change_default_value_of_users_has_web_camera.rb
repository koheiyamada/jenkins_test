class ChangeDefaultValueOfUsersHasWebCamera < ActiveRecord::Migration
  def up
    change_column :users, :has_web_camera, :string, :default => 'built_in'
  end

  def down
    change_column :users, :has_web_camera, :string, :default => 'no'
  end
end
