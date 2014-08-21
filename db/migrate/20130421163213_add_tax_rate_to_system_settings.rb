class AddTaxRateToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :tax_rate, :float, :default => 0.05
  end
end
