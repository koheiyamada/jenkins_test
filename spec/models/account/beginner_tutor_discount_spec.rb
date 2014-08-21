# encoding:utf-8
require 'spec_helper'

describe Account::BeginnerTutorDiscount do
  describe ".create" do
    let(:student) {FactoryGirl.create(:student)}
    let(:tutor) {FactoryGirl.create(:tutor)}
    before(:each) do
      tutor.anytime_available = true
      @subject = FactoryGirl.create(:subject)
      @t = 1.hour.from_now
      @lesson = FactoryGirl.create(:optional_lesson, tutor:tutor, subject:@subject, students:[student], start_time:@t, units:1)
    end

    describe "作成する" do
      it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
        Account::BeginnerTutorDiscount.new(owner:student, year:@lesson.payment_month.year,
                                         month:@lesson.payment_month.month,
                                         client:Headquarter.instance,
                                         amount_of_money_received:@lesson.tutor_base_wage,
                                         lesson:@lesson
        ).should be_valid
      end
    end
  end
end
