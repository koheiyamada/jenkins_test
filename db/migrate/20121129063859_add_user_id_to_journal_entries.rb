class AddUserIdToJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :user_id, :integer
    add_index :account_journal_entries, :user_id
  end
end
