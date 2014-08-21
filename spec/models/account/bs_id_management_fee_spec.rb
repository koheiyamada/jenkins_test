# encoding:utf-8
require 'spec_helper'

describe Account::BsIdManagementFee do
  describe ".create" do
    let(:bs) {FactoryGirl.create(:bs)}
    let(:today) {Date.today}

    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::BsIdManagementFee.new(
        owner:bs,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_payment: 100000
      ).should be_valid
    end
  end
end
