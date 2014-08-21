# coding:utf-8

require 'spec_helper'

describe Account::HqUserReferenceDiscount do
  it '月日、金額がいる' do
    entry = FactoryGirl.build(:account_hq_user_reference_discount)
    entry.should be_valid
  end

  it '月日が欠けているとだめ' do
    entry = FactoryGirl.build(:account_hq_user_reference_discount, year: nil, month:nil)
    entry.should_not be_valid
  end

  it '金額が欠けているとだめ' do
    entry = FactoryGirl.build(:account_hq_user_reference_discount, amount_of_money_received: nil)
    entry.should_not be_valid
  end

  it 'オーナーが欠けているとだめ' do
    entry = FactoryGirl.build(:account_hq_user_reference_discount, owner: nil)
    entry.should_not be_valid
  end

  context 'すでに同じ月の項目がある' do
    before(:each) do
      entry = FactoryGirl.create(:account_hq_user_reference_discount)
      @owner = entry.owner
    end

    it '同じ月に項目を追加できない。' do
      entry = FactoryGirl.build(:account_hq_user_reference_discount,
                                owner: @owner,
                                amount_of_money_received: 200)
      entry.should_not be_valid
    end
  end
end
