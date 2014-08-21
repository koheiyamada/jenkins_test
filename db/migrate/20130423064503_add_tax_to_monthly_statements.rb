class AddTaxToMonthlyStatements < ActiveRecord::Migration
  def change
    add_column :monthly_statements, :tax_of_payment, :integer, :default => 0
    add_column :monthly_statements, :tax_of_money_received, :integer, :default => 0
  end
end
