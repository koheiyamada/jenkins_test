class AddCutoffDateToSystemSettings < ActiveRecord::Migration
  def change
    add_column :system_settings, :cutoff_date, :integer, :default => 20
  end
end
