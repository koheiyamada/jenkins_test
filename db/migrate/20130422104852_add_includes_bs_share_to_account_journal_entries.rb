class AddIncludesBsShareToAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :includes_bs_share, :boolean, :default => false
  end
end
