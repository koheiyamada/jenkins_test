# coding:utf-8
require 'spec_helper'

describe StudentMoneyMethods do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:hq_user) {FactoryGirl.create(:hq_user)}
  subject {FactoryGirl.create(:student)}

  describe '#update_monthly_journal_entries!' do
    let(:today) {Date.today}

    [
      {enrolled_at: Time.current.change(day: SystemSettings.cutoff_date), charge: false},
      {enrolled_at: 1.month.ago(Time.current).change(day: SystemSettings.cutoff_date + 1), charge: false},
      {enrolled_at: 1.month.ago(Time.current).change(day: SystemSettings.cutoff_date), charge: true},
    ].each do |config|
      context "#{config[:enrolled_at]}に入会した受講者の場合" do
        before(:each) do
          subject.class.any_instance.stub(:enrolled_at){config[:enrolled_at]}
        end

        if config[:charge]
          it 'ID管理費は発生する' do
            expect {
              subject.update_monthly_journal_entries!(today.year, today.month)
            }.to change(Account::StudentIdManagementFee, :count).by(1)
          end
        else
          it 'ID管理費は発生しない' do
            expect {
              subject.update_monthly_journal_entries!(today.year, today.month)
            }.not_to change(Account::StudentIdManagementFee, :count)
          end
        end
      end
    end
  end

  describe 'can_pay_lesson_extension_fee?' do
    before(:each) do
      @lesson = mock_model(Lesson)
      @lesson.stub(:extension_fee){100}
      @lesson.stub(:payment_month){Date.today}
      subject.stub(:max_charge){200}
    end

    it '月の制限の範囲内であればtrueを返す' do
      subject.stub(:lesson_charge_of_month){100}
      subject.can_pay_lesson_extension_fee?(@lesson).should be_true
    end

    it '月の制限を超えていればfalseを返す' do
      subject.stub(:lesson_charge_of_month){101}
      subject.can_pay_lesson_extension_fee?(@lesson).should be_false
    end
  end
end
