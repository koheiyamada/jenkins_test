class AddReversedEntryIdToAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :reversal_entry_id, :integer
  end
end
