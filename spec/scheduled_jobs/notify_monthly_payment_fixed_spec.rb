# coding:utf-8

require 'spec_helper'

describe NotifyMonthlyPaymentFixed do
  describe '.execute' do
    context '保護者がいる' do
      let(:parent){FactoryGirl.create(:active_parent)}
      before(:each) do
        parent.monthly_statement_of_month(Date.today.year, Date.today.month)
      end

      it '保護者にsend_mailが呼ばれる' do
        NotifyMonthlyPaymentFixed.should_receive(:notify_to_parent)
        NotifyMonthlyPaymentFixed.execute
      end
    end

    context '受講者がいる' do
      let(:student){FactoryGirl.create(:active_student)}

      before(:each) do
        student.monthly_statement_of_month(Date.today.year, Date.today.month)
      end

      it 'notify_to_studentが呼ばれる' do
        NotifyMonthlyPaymentFixed.should_receive(:notify_to_student)
        NotifyMonthlyPaymentFixed.execute
      end
    end
  end
end
