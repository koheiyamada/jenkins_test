class CreateLedgers < ActiveRecord::Migration
  def change
    create_table :ledgers do |t|
      t.string  :type
      t.integer :ledgerable_id
      t.string  :ledgerable_type
      t.date :month
      t.integer :entry_fee, :default => 0
      t.integer :bs_id_management_fee, :default => 0
      t.integer :student_id_management_fee, :default => 0
      t.integer :textbook_usage_fee, :default => 0
      t.integer :basic_lesson_tutor_fee, :default => 0
      t.integer :optional_lesson_tutor_fee, :default => 0
      t.integer :tutor_referral_fee, :default => 0
      t.integer :student_referral_fee, :default => 0
      t.integer :basic_lesson_fee, :default => 0
      t.integer :optional_lesson_fee, :default => 0
      t.integer :examination_fee, :default => 0
      t.integer :lesson_sale_amount, :length => 8, :default => 0
      t.integer :scoring_fee, :default => 0
      t.integer :textbook_rental_fee, :default => 0
      t.integer :bs_textbook_rental_fee, :default => 0
      t.integer :soba_id_management_fee, :default => 0
      t.integer :beginner_tutor_discount, :default => 0
      t.integer :group_lesson_discount, :default => 0
      t.integer :group_lesson_premium, :default => 0
      t.integer :lesson_delay_reduction, :default => 0
      t.integer :lesson_cancellation_pemalty, :default => 0
      t.boolean :closed, :default => false

      t.timestamps
    end
    add_index :ledgers, :type
    add_index :ledgers, :ledgerable_id
    add_index :ledgers, :ledgerable_type
  end
end
