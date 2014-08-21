class CreateRateSettings < ActiveRecord::Migration
  def change
    create_table :rate_settings do |t|
      t.string :name
      t.float :rate, :default => 0

      t.timestamps
    end
    add_index :rate_settings, :name
  end
end
