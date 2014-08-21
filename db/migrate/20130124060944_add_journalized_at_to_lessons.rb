class AddJournalizedAtToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :journalized_at, :datetime
  end
end
