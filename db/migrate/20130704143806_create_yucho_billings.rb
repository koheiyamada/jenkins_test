class CreateYuchoBillings < ActiveRecord::Migration
  def change
    create_table :yucho_billings do |t|
      t.references :yucho_account
      t.references :monthly_statement
      t.integer :amount, :null => false, :default => 0

      t.timestamps
    end
    add_index :yucho_billings, :yucho_account_id
    add_index :yucho_billings, :monthly_statement_id
  end
end
