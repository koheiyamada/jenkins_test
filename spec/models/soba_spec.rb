# coding:utf-8

require 'spec_helper'

describe Soba do
  subject {FactoryGirl.create :soba}

  describe '#update_monthly_journal_entries!' do
    context '1月前以上に入会した受講者がいる' do
      before(:each) do
        @student = FactoryGirl.create(:student)
        @student.update_column :created_at, 2.months.ago
      end

      it '人数に応じた仕訳データが作られる' do
        d = Date.today
        expect {
          subject.update_monthly_journal_entries!(d.year, d.month)
        }.to change(Account::SobaIdManagementFee, :count).by(1)
      end

      it '金額は１人分' do
        d = Date.today
        subject.update_monthly_journal_entries!(d.year, d.month)
        fee = Account::SobaIdManagementFee.last
        fee.amount_of_money_received = 500
      end
    end
  end
end
