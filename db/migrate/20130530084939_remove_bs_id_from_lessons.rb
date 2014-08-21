class RemoveBsIdFromLessons < ActiveRecord::Migration
  def up
    remove_column :lessons, :bs_id
  end

  def down
    add_column :lessons, :bs_id, :integer
    add_index :lessons, :bs_id
  end
end
