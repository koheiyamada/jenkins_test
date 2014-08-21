class CreateMitsubishiTokyoUfjAccounts < ActiveRecord::Migration
  def change
    create_table :mitsubishi_tokyo_ufj_accounts do |t|
      t.string :branch_name
      t.string :branch_code
      t.string :account_number
      t.string :account_holder_name
      t.string :account_holder_name_kana

      t.timestamps
    end
  end
end
