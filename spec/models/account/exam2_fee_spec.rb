# encoding:utf-8
require 'spec_helper'

describe Account::Exam2Fee do
  describe ".create" do
    let(:student) {FactoryGirl.create(:student)}
    let(:today) {Date.today}

    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::Exam2Fee.new(
        owner:student,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_payment: 10000
      ).should be_valid
    end
  end
end
