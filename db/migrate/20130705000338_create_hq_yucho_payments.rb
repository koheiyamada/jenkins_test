class CreateHqYuchoPayments < ActiveRecord::Migration
  def change
    create_table :hq_yucho_payments do |t|
      t.references :yucho_account
      t.references :monthly_statement
      t.integer :amount, :null => false, :default => 0

      t.timestamps
    end
    add_index :hq_yucho_payments, :yucho_account_id
    add_index :hq_yucho_payments, :monthly_statement_id
  end
end
