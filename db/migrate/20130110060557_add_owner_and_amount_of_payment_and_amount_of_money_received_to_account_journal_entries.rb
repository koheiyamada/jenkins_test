class AddOwnerAndAmountOfPaymentAndAmountOfMoneyReceivedToAccountJournalEntries < ActiveRecord::Migration
  def change
    add_column :account_journal_entries, :owner_id, :integer
    add_column :account_journal_entries, :owner_type, :string
    add_column :account_journal_entries, :amount_of_payment, :integer, :length => 8
    add_column :account_journal_entries, :amount_of_money_received, :integer, :length => 8
    add_column :account_journal_entries, :client_id, :integer
    add_column :account_journal_entries, :client_type, :string

    add_index :account_journal_entries, [:owner_id, :owner_type]
    add_index :account_journal_entries, [:client_id, :client_type]
  end
end
