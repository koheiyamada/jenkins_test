class CreateAccountJournalEntries < ActiveRecord::Migration
  def change
    create_table :account_journal_entries do |t|
      t.string :type
      t.references :payer
      t.references :payee
      t.integer :amount
      t.date :settlement_date

      t.timestamps
    end
    add_index :account_journal_entries, :type
    add_index :account_journal_entries, :payer_id
    add_index :account_journal_entries, :payee_id
  end
end
