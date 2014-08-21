class AddBankIdToBankAccount < ActiveRecord::Migration
  def change
    add_column :bank_accounts, :bank_id, :integer
    add_index :bank_accounts, :bank_id
  end
end
