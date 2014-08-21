class RemoveSettlementDateFromAccountJournalEntries < ActiveRecord::Migration
  def up
    remove_column :account_journal_entries, :settlement_date

    remove_index :account_journal_entries, :payer_id
    remove_index :account_journal_entries, :payer_type
    remove_index :account_journal_entries, :payee_id
    remove_index :account_journal_entries, :payee_type

    remove_column :account_journal_entries, :payer_id
    remove_column :account_journal_entries, :payer_type
    remove_column :account_journal_entries, :payee_id
    remove_column :account_journal_entries, :payee_type

    remove_column :account_journal_entries, :amount
  end

  def down
    add_column :account_journal_entries, :amount, :integer
    r
    add_column :account_journal_entries, :payee_type, :string
    add_column :account_journal_entries, :payee_id, :integer
    add_column :account_journal_entries, :payer_type, :string
    add_column :account_journal_entries, :payer_id, :integer

    add_index :account_journal_entries, :payer_id
    add_index :account_journal_entries, :payer_type
    add_index :account_journal_entries, :payee_id
    add_index :account_journal_entries, :payee_type

    add_column :account_journal_entries, :settlement_date, :date
  end
end
