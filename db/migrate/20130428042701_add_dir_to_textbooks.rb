class AddDirToTextbooks < ActiveRecord::Migration
  def change
    add_column :textbooks, :dir, :string
  end
end
