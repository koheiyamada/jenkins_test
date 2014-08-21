class CreateMonthlyStatementCalculations < ActiveRecord::Migration
  def change
    create_table :monthly_statement_calculations do |t|
      t.integer :year
      t.integer :month
      t.string :status, :default => 'new'

      t.timestamps
    end
  end
end
