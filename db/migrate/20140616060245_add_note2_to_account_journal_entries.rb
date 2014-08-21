class AddNote2ToAccountJournalEntries < ActiveRecord::Migration
  def change
  	add_column :account_journal_entries, :note2, :string
  end
end
