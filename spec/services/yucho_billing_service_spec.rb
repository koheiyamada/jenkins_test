# coding:utf-8

require 'spec_helper'

describe YuchoBillingService do
  let(:student) {FactoryGirl.create(:active_student)}
  let(:today) {Date.today}
  let(:monthly_statement) {MonthlyStatement.create!(owner:student, year:today.year, month:today.month)}
  subject{YuchoBillingService.new}

  before(:each) do
    attrs = FactoryGirl.attributes_for(:yucho_account)
    account = student.create_account_of_bank(:yucho, attrs)
    account.should be_persisted
  end

  describe '#monthly_statement_to_yucho_billing' do
    before(:each) do
      @ms = MonthlyStatement.create!(owner:student, year:today.year, month:today.month, amount_of_payment: rand(100000) + 1)
    end

    it 'YuchoBillingを作成する' do
      ms = MonthlyStatement.create!(owner:student, year:today.year, month:today.month)
      expect {
        subject.monthly_statement_to_yucho_billing(ms)
      }.to change(YuchoBilling, :count).by(1)
    end

    it '請求額は月次集計の支払額と同じ' do
      billing = subject.monthly_statement_to_yucho_billing(@ms)
      billing.amount.should > 0
      billing.amount.should == @ms.amount_of_payment
    end
  end
end
