class AddBsIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :bs_id, :integer
    add_index :lessons, :bs_id
  end
end
