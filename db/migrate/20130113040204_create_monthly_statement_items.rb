class CreateMonthlyStatementItems < ActiveRecord::Migration
  def change
    create_table :monthly_statement_items do |t|
      t.integer :monthly_statement_id
      t.integer :year
      t.integer :month
      t.string  :account_item
      t.integer :amount_of_payment, :length => 8, :default => 0
      t.integer :amount_of_money_received, :length => 8, :default => 0

      t.timestamps
    end
    add_index :monthly_statement_items, :account_item
    add_index :monthly_statement_items, :monthly_statement_id
  end
end
