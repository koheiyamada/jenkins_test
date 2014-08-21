class CreateTutorMonthlyIncomes < ActiveRecord::Migration
  def change
    create_table :tutor_monthly_incomes do |t|
      t.references :tutor
      t.integer :year
      t.integer :month
      t.integer :current_amount, :default => 0
      t.integer :expected_amount, :default => 0

      t.timestamps
    end

    add_index :tutor_monthly_incomes, :tutor_id
  end
end
