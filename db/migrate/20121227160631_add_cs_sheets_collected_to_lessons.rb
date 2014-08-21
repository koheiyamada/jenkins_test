class AddCsSheetsCollectedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :cs_sheets_collected, :boolean, :default => false
  end
end
