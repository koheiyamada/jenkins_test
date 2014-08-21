class CreateNoChargingUsers < ActiveRecord::Migration
  def change
    create_table :no_charging_users do |t|
      t.references :user, null: false

      t.timestamps
    end
    add_index :no_charging_users, :user_id
  end
end
