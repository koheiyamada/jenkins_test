class AddSizeToUserFile < ActiveRecord::Migration
  def change
    add_column :user_files, :size, :integer, default: 0
  end
end
