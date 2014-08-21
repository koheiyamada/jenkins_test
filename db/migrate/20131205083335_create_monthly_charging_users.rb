class CreateMonthlyChargingUsers < ActiveRecord::Migration
  def change
    create_table :monthly_charging_users, id: false do |t|
      t.integer :year, null: false
      t.integer :month, null: false
      t.references :user, null: false
      t.string :user_type, null: false
      t.string :user_name, null: false
      t.string :full_name, null: false

      t.timestamps
    end
    add_index :monthly_charging_users, :user_id
  end
end
