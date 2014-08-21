class ModifyAmountColumnsOfAccountJournalEntries < ActiveRecord::Migration
  def up
    change_column :account_journal_entries, :amount_of_money_received, :integer, :default => 0
    change_column :account_journal_entries, :amount_of_payment, :integer, :default => 0
  end

  def down
    change_column :account_journal_entries, :amount_of_money_received, :integer
    change_column :account_journal_entries, :amount_of_payment, :integer
  end
end
