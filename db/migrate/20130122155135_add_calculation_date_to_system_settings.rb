class AddCalculationDateToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :calculation_date, :integer, :default => 26
  end
end
