class AddCsPointToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :cs_point, :float
  end
end
