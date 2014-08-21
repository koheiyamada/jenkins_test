class AddPayeeTypeToJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :payee_type, :string
    add_index :account_journal_entries, :payee_type
  end
end
