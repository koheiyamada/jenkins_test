class CreateDealBases < ActiveRecord::Migration
  def change
    create_table :deal_bases do |t|
      t.string :type
      t.integer :payer_id
      t.string :payer_type
      t.integer :payee_id
      t.string :payee_type
      t.integer :year
      t.integer :month
      t.integer :amount, :length => 8, :default => 0
      t.integer :lesson_id

      t.timestamps
    end

    add_index :deal_bases, [:payer_id, :payer_type]
    add_index :deal_bases, [:payee_id, :payee_type]
    add_index :deal_bases, :lesson_id
    add_index :deal_bases, :type
  end
end
