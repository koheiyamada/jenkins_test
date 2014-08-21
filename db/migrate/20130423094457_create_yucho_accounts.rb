class CreateYuchoAccounts < ActiveRecord::Migration
  def change
    create_table :yucho_accounts do |t|
      t.string :kigo1
      t.string :kigo2
      t.string :bango
      t.string :account_holder_name
      t.string :account_holder_name_kana

      t.timestamps
    end
  end
end
