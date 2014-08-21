# encoding:utf-8
require 'spec_helper'

describe Account::LessonSaleAmount do
  describe ".create" do
    let(:bs) {FactoryGirl.create(:bs)}
    let(:student) {FactoryGirl.create(:student)}
    let(:tutor) {FactoryGirl.create(:tutor)}
    let(:subject) {FactoryGirl.create(:subject)}
    let(:lesson) {FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:1.hour.from_now, units:1)}
    let(:today) {Date.today}

    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::LessonSaleAmount.new(
        owner:bs,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_money_received: 10000
      ).should be_valid
    end
  end
end
