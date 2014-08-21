class AddCalculatedToBsMonthlyResults < ActiveRecord::Migration
  def change
    add_column :bs_monthly_results, :calculated, :boolean, :default => false
  end
end
