# encoding:utf-8
require 'spec_helper'

describe Account::OptionalLessonFee do
  let(:bs) {FactoryGirl.create(:bs)}
  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:lesson) {FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:1.hour.from_now, units:1)}
  let(:today) {Date.today}

  it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
    Account::OptionalLessonFee.new(
      owner:student,
      year: today.year,
      month: today.month,
      client:Headquarter.instance,
      amount_of_payment: 10000,
      lesson:lesson
    ).should be_valid
  end

  describe "反対仕分けをする" do
    before(:each) do
      @entry = Account::OptionalLessonFee.create!(
        owner:student,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_payment: 10000,
        lesson:lesson
      )
    end

    it "金額が入れ替わる" do
      reversed = @entry.create_reversal_entry!
      reversed.amount_of_payment.should == @entry.amount_of_money_received
      reversed.amount_of_money_received.should == @entry.amount_of_payment
    end

    it "その他は同じ" do
      reversed = @entry.create_reversal_entry!
      reversed.owner.should == @entry.owner
      month = Account::JournalEntry.settlement_month_of_day(today)
      reversed.year.should == month.year
      reversed.month.should == month.month
      reversed.lesson_id.should == @entry.lesson_id
    end

    it "reversed?がtrueになる" do
      expect {
        @entry.create_reversal_entry!
      }.to change{Account::JournalEntry.find(@entry.id).reversed?}.from(false).to(true)
    end
  end
end
