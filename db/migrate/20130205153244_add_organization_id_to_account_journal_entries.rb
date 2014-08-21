class AddOrganizationIdToAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :organization_id, :integer
    add_index :account_journal_entries, :organization_id
  end
end
