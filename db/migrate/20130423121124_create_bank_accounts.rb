class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.integer :owner_id
      t.string :owner_type
      t.integer :account_id
      t.string :account_type

      t.timestamps
    end

    add_index :bank_accounts, :owner_id
    add_index :bank_accounts, :owner_type
    add_index :bank_accounts, :account_id
    add_index :bank_accounts, :account_type
  end
end
