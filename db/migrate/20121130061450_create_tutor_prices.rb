class CreateTutorPrices < ActiveRecord::Migration
  def change
    create_table :tutor_prices do |t|
      t.references :tutor
      t.integer :lesson_fee
      t.integer :hourly_wage

      t.timestamps
    end
    add_index :tutor_prices, :tutor_id
  end
end
