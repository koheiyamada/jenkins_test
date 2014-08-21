class AddPayerTypeToAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :payer_type, :string
    add_index :account_journal_entries, :payer_type
  end
end
