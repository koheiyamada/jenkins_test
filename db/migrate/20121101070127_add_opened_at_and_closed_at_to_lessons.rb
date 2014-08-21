class AddOpenedAtAndClosedAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :opened_at, :datetime
    add_column :lessons, :closed_at, :datetime
  end
end
