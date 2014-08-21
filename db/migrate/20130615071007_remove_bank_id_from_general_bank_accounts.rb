class RemoveBankIdFromGeneralBankAccounts < ActiveRecord::Migration
  def up
    remove_column :general_bank_accounts, :bank_id
  end

  def down
    add_column :general_bank_accounts, :bank_id, :integer
    add_index :general_bank_accounts, :bank_id
  end
end
