# encoding:utf-8
require 'spec_helper'

describe Account::EntryFee do
  let(:student) {FactoryGirl.create(:student)}
  let(:today) {Date.today}

  describe ".create" do
    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::EntryFee.new(
        owner:student,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_money_received: 10000
      ).should be_valid
    end
  end
end
