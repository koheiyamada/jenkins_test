class AddTextbookSetIdToTextbooks < ActiveRecord::Migration
  def change
    add_column :textbooks, :textbook_set_id, :integer, :default => 1
  end
end