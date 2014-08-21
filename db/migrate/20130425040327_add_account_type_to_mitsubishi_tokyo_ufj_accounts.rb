class AddAccountTypeToMitsubishiTokyoUfjAccounts < ActiveRecord::Migration
  def change
    add_column :mitsubishi_tokyo_ufj_accounts, :account_type, :string, :default => 'savings'
  end
end
