class AddNoteToAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :note, :string
  end
end
