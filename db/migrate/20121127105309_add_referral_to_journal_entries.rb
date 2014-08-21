class AddReferralToJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :referral_id, :integer
    add_index :account_journal_entries, :referral_id
  end
end
