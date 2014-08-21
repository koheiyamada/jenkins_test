class DropLedgers < ActiveRecord::Migration
  def up
    drop_table :ledgers
  end

  def down
    create_table "ledgers", :force => true do |t|
      t.string   "type"
      t.integer  "ledgerable_id"
      t.string   "ledgerable_type"
      t.date     "month"
      t.integer  "entry_fee",                   :default => 0
      t.integer  "bs_id_management_fee",        :default => 0
      t.integer  "student_id_management_fee",   :default => 0
      t.integer  "textbook_usage_fee",          :default => 0
      t.integer  "basic_lesson_tutor_fee",      :default => 0
      t.integer  "optional_lesson_tutor_fee",   :default => 0
      t.integer  "tutor_referral_fee",          :default => 0
      t.integer  "student_referral_fee",        :default => 0
      t.integer  "basic_lesson_fee",            :default => 0
      t.integer  "optional_lesson_fee",         :default => 0
      t.integer  "examination_fee",             :default => 0
      t.integer  "lesson_sale_amount",          :default => 0
      t.integer  "scoring_fee",                 :default => 0
      t.integer  "textbook_rental_fee",         :default => 0
      t.integer  "bs_textbook_rental_fee",      :default => 0
      t.integer  "soba_id_management_fee",      :default => 0
      t.integer  "beginner_tutor_discount",     :default => 0
      t.integer  "group_lesson_discount",       :default => 0
      t.integer  "group_lesson_premium",        :default => 0
      t.integer  "lesson_delay_reduction",      :default => 0
      t.integer  "lesson_cancellation_penalty", :default => 0
      t.boolean  "closed",                      :default => false
      t.datetime "created_at",                                     :null => false
      t.datetime "updated_at",                                     :null => false
      t.integer  "exam2_fee",                   :default => 0
      t.integer  "exam3_fee",                   :default => 0
      t.integer  "exam4_fee",                   :default => 0
      t.integer  "exam5_fee",                   :default => 0
    end

    add_index "ledgers", ["ledgerable_id"], :name => "index_ledgers_on_ledgerable_id"
    add_index "ledgers", ["ledgerable_type"], :name => "index_ledgers_on_ledgerable_type"
    add_index "ledgers", ["type"], :name => "index_ledgers_on_type"
  end
end
