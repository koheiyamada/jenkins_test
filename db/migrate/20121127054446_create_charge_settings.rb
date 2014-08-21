class CreateChargeSettings < ActiveRecord::Migration
  def change
    create_table :charge_settings do |t|
      t.string :name
      t.integer :amount

      t.timestamps
    end

    add_index :charge_settings, :name
  end
end
