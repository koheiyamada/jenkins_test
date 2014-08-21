# coding:utf-8
require 'spec_helper'

describe Account::JournalEntry do
  describe ".period_of_settlement_month" do
    it "前月の締め日翌日から今月の締め日までのRangeを返す" do
      period = Account::JournalEntry.period_of_settlement_month 2013, 4
      period.first.year.should == 2013
      period.first.month.should == 3
      period.first.day.should == 21

      period.last.year.should == 2013
      period.last.month.should == 4
      period.last.day.should == 20
    end
  end
end
