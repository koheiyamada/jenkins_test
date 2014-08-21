class CreateMonthlyStatements < ActiveRecord::Migration
  def change
    create_table :monthly_statements do |t|
      t.integer :owner_id
      t.string  :owner_type
      t.integer :year
      t.integer :month
      t.integer :amount_of_payment, :length => 8, :default => 0
      t.integer :amount_of_money_received, :length => 8, :default => 0

      t.timestamps
    end
    add_index :monthly_statements, [:owner_id, :owner_type]
  end
end
