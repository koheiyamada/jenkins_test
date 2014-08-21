class CreateTutorPriceHistories < ActiveRecord::Migration
  def change
    create_table :tutor_price_histories do |t|
      t.references :tutor
      t.integer :hourly_wage

      t.timestamps
    end
    add_index :tutor_price_histories, :tutor_id
  end
end
