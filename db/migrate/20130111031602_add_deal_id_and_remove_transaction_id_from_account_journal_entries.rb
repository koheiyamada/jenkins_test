class AddDealIdAndRemoveTransactionIdFromAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :deal_id, :integer
    add_index :account_journal_entries, :deal_id
  end
end
