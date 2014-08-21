class AddWidthAndHeightToTextbooks < ActiveRecord::Migration
  def change
    add_column :textbooks, :width, :integer
    add_column :textbooks, :height, :integer
  end
end
