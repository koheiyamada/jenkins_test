# coding:utf-8

require 'spec_helper'

describe ChargeEntryFee do

  describe '.execute' do
    it '入会31日目以降の受講者に入会金を課す' do
      s1 = FactoryGirl.create(:active_student, enrolled_at: 31.days.ago.to_time)
      s2 = FactoryGirl.create(:active_student, enrolled_at: 30.days.ago.to_time)
      s3 = FactoryGirl.create(:active_student, enrolled_at: 31.days.ago.to_time)
      s3.create_entry_fee!
      s4 = FactoryGirl.create(:active_student, enrolled_at: 32.days.ago.to_time)
      s5 = FactoryGirl.create(:active_student, enrolled_at: 30.days.ago.to_time)
      s5.create_entry_fee!

      expect {
        ChargeEntryFee.execute
      }.to change(Account::EntryFee, :count).by(2)

      payers = Account::EntryFee.all.map(&:owner)
      [s1, s4].all?{|s| payers.include?(s)}.should be_true
    end

    it '退会した受講者には課金しない' do
      s1 = FactoryGirl.create(:active_student, enrolled_at: 31.days.ago.to_time)
      s1.leave('boring')

      expect {
        ChargeEntryFee.execute
      }.not_to change(Account::EntryFee, :count)

      payers = Account::EntryFee.all.map(&:owner)
      payers.should be_empty
    end
  end
end
