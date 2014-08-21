# encoding:utf-8
require 'spec_helper'

describe Account::TutorReferralFee do
  describe ".create" do
    let(:bs) {FactoryGirl.create(:bs)}
    let(:student) {FactoryGirl.create(:student)}
    let(:tutor) {FactoryGirl.create(:tutor)}
    let(:tutor2) {FactoryGirl.create(:tutor, user_name:"tutor2")}
    let(:subject) {FactoryGirl.create(:subject)}
    let(:lesson) {FactoryGirl.create(:optional_lesson, tutor:tutor, subject:subject, students:[student], start_time:1.hour.from_now, units:1)}
    let(:today) {Date.today}

    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::TutorReferralFee.new(
        owner:tutor,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_money_received: 10000,
        referral: tutor2
      ).should be_valid
    end
  end
end
