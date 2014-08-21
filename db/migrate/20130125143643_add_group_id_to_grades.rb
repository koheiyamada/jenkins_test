class AddGroupIdToGrades < ActiveRecord::Migration
  def change
    add_column :grades, :group_id, :integer
    add_index :grades, :group_id
  end
end
