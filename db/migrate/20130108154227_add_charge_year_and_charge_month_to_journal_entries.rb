class AddChargeYearAndChargeMonthToJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :year, :integer
    add_column :account_journal_entries, :month, :integer
    add_index :account_journal_entries, :year
    add_index :account_journal_entries, :month
  end
end
