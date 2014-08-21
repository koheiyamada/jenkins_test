# encoding:utf-8
require 'spec_helper'

describe Account::Item do
  describe ".all" do
    it "文字列のリストを返す" do
      Account::Item.all.should be_a(Array)
      Account::Item.all.each do |item|
        item.should be_present
        item.should be_a(String)
      end
    end

    it "要素は２４個ある" do
      Account::Item.all.should have(24).items
    end
  end

  describe ".items_for_role" do
    it "生徒向けは12個" do
      Account::Item.items_for(:student).should have(12).items
    end

    it "チューター向けは6個" do
      Account::Item.items_for(:tutor).should have(6).items
    end

    it "BS向けは4個" do
      Account::Item.items_for(:bs).should have(4).items
    end

    it "テキスト会社向けは１個" do
      Account::Item.items_for(:textbook_company).should have(1).items
    end

    it "SOBA向けは１個" do
      Account::Item.items_for(:soba).should have(1).items
    end

    it "文字列の配列を返す" do
      %w(student tutor bs textbook_company soba).map(&:to_sym).each do |role|
        items = Account::Item.items_for(role)
        items.should be_a(Array)
        items.size.should > 0
        items.each do |item|
          item.should be_a(String)
        end
      end
    end
  end
end