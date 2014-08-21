# encoding:utf-8
require 'spec_helper'

describe Account::BsTextbookRentalFee do
  describe ".create" do
    let(:bs) {FactoryGirl.create(:bs)}
    let(:student) {FactoryGirl.create(:student)}
    let(:today) {Date.today}

    before(:each) do
      @subject = FactoryGirl.create(:subject)
    end

    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::BsTextbookRentalFee.new(
        owner:bs,
        year: today.year,
        month: today.month,
        client:Headquarter.instance,
        amount_of_money_received: 10000
      ).should be_valid
    end
  end
end
