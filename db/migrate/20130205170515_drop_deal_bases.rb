class DropDealBases < ActiveRecord::Migration
  def up
    drop_table :deal_bases
  end

  def down
    create_table "deal_bases", :force => true do |t|
      t.string   "type"
      t.integer  "payer_id"
      t.string   "payer_type"
      t.integer  "payee_id"
      t.string   "payee_type"
      t.integer  "year"
      t.integer  "month"
      t.integer  "amount",          :default => 0
      t.integer  "lesson_id"
      t.datetime "created_at",                     :null => false
      t.datetime "updated_at",                     :null => false
      t.integer  "item_count"
      t.integer  "referral_id"
      t.integer  "organization_id"
    end

    add_index "deal_bases", ["lesson_id"], :name => "index_deal_bases_on_lesson_id"
    add_index "deal_bases", ["organization_id"], :name => "index_deal_bases_on_organization_id"
    add_index "deal_bases", ["payee_id", "payee_type"], :name => "index_deal_bases_on_payee_id_and_payee_type"
    add_index "deal_bases", ["payer_id", "payer_type"], :name => "index_deal_bases_on_payer_id_and_payer_type"
    add_index "deal_bases", ["referral_id"], :name => "index_deal_bases_on_referral_id"
    add_index "deal_bases", ["type"], :name => "index_deal_bases_on_type"
  end
end
