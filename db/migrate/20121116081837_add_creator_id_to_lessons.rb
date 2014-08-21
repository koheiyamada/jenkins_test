class AddCreatorIdToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :creator_id, :integer
    add_index :lessons, :creator_id
  end
end
