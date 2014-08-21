class AddPaidToMonthlyStatements < ActiveRecord::Migration
  def change
    add_column :monthly_statements, :paid, :boolean, :default => false
  end
end
