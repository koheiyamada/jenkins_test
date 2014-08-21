class CreateGeneralBankAccounts < ActiveRecord::Migration
  def change
    create_table :general_bank_accounts do |t|
      t.integer :bank_id
      t.string :branch_name
      t.string :branch_code
      t.string :account_type, :default => 'savings'
      t.string :account_number
      t.string :account_holder_name
      t.string :account_holder_name_kana

      t.timestamps
    end

    add_index :general_bank_accounts, :bank_id
  end
end
