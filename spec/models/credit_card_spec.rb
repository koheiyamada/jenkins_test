# encoding: utf-8
require 'spec_helper'

def random_string(length)
  1.upto(length).map{ ('a'..'z').to_a[rand(26)] }.join
end

def random_number_string(length)
  1.upto(length).map{ ('0'..'9').to_a[rand(10)] }.join
end

describe CreditCard do
  disconnect_sunspot

  before(:each) do
    @credit_card = CreditCard.new
  end

  context "#number" do
    it "が与えられていない場合はエラー" do
      expect {
        @credit_card.valid?
      }.to change { @credit_card.errors[:number].size }.from(0).to(1)
    end

    context "が正しい場合" do
      # all test number
      [
        '4111111111111111',  # VISA
        '5555555555554444',  # Master
        '3528000000000007',  # JCB
        '3528000000000015',  # JCB
        '3528000000000023',  # JCB
        '378282246310005',   # AMEX
        '36666666666660',    # Diners
      ].each do |number|
        it "であればエラーは追加されない [#{number}]" do
          @credit_card.number = number
          @credit_card.valid?
          @credit_card.errors[:number].should be_empty
        end
      end
    end

    context "が正しくない場合" do
      [
        '0',
        '1',
        '1111111111111',
        '11111111111111',
        '111111111111111',
        'aaaaaaaaaaaaaa',
        'aaaaaaaaaaaaaaa',
        '11111111111111a',
      ].each do |number|
        it "はエラーが追加される [#{number}]" do
          expect {
            @credit_card.number = number
            @credit_card.valid?
          }.to change { @credit_card.errors[:number].size }.from(0).to(1)
        end
      end
    end
  end

  context "#expire" do
    date = 2000.years.ago.to_date

    it "が与えられていない場合はエラー" do
      expect {
        @credit_card.valid?
      }.to change { @credit_card.errors[:expire].size }.from(0).to(1)
    end

    context "が正しい場合" do
      [
        date,
        date + 1.day,
        date + 2.day,
        date + 1.month,
        date + 1.year,
      ].each do |expire|
        it "であればエラーは追加されない [#{expire}]" do
          @credit_card.expire = expire
          @credit_card.valid?
          @credit_card.errors[:expire].should be_empty
        end
      end
    end

    context "が正しくない場合" do
      [
        date - 1.day,
        date - 2.day,
        date - 1.month,
        date - 1.year,
      ].each do |expire|
        it "はエラーが追加される [#{expire}]" do
          expect {
            @credit_card.expire = expire
            @credit_card.valid?
          }.to change { @credit_card.errors[:expire].size }.from(0).to(1)
        end
      end
    end
  end

  context "#security_code" do
    it "が与えられていない場合はエラー" do
      expect {
        @credit_card.valid?
      }.to change { @credit_card.errors[:security_code].size }.from(0).to(3)  # 3 is presence, length and numericality
    end

    (0..20).map{ random_number_string(rand(3..4)) }.each do |security_code|
      it "が3桁もしくは4桁ならエラーにならない [#{security_code}]" do
        @credit_card.security_code = security_code
        @credit_card.valid?
        @credit_card.errors[:security_code].should be_empty
      end
    end

    ([1, 2] + (5..10).to_a).map{|i| '1' * i}.each do |security_code|
      it "が3桁もしくは4桁以外の場合はエラー [#{security_code}]" do
        expect {
          @credit_card.security_code = security_code
          @credit_card.valid?
        }.to change { @credit_card.errors[:security_code].size }.from(0).to(1)
      end
    end

    (0..20).map{ random_string(rand(3..4)) }.each do |security_code|
      it "が全て数字でなければエラー [#{security_code}]" do
        expect {
          @credit_card.security_code = security_code
          @credit_card.valid?
        }.to change { @credit_card.errors[:security_code].size }.from(0).to(1)
      end
    end
  end
end
