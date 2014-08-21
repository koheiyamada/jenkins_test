class AddReferralIdToDealBases < ActiveRecord::Migration
  def change
    add_column :deal_bases, :referral_id, :integer
    add_index :deal_bases, :referral_id
  end
end
