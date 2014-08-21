class CreateBsMonthlyResults < ActiveRecord::Migration
  def change
    create_table :bs_monthly_results do |t|
      t.references :organization
      t.integer :year
      t.integer :month
      t.integer :lesson_sales_amount, :length => 8, :default => 0

      t.timestamps
    end
    add_index :bs_monthly_results, :organization_id
    add_index :bs_monthly_results, [:year, :month]
  end
end
