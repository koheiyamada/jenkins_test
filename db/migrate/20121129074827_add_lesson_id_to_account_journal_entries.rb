class AddLessonIdToAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :lesson_id, :integer
    add_index :account_journal_entries, :lesson_id
  end
end
