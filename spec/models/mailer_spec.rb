# coding:utf-8
require 'spec_helper'

describe Mailer do
  describe '.time_next_morning' do
    it '現在がメール送信可能期間前なら当日の7時を返す' do
      (0..6).each do |h|
        time = Time.current.change(hour: h)
        Time.stub(:current){time}
        t = Mailer.time_next_morning
        t.should be_today
        t.hour.should == 7
        t.min.should == 0
      end
    end

    it '現在メール送信可能開始時刻を過ぎていれば翌日の7時を返す' do
      (7..23).each do |h|
        time = Time.current.change(hour: h)
        Time.stub(:current){time}
        t = Mailer.time_next_morning
        t.to_date.should == Date.tomorrow
        t.hour.should == 7
        t.min.should == 0
      end
    end
  end

  describe '.next_appropriate_time?' do
    it '現在がメール送信可能期間前なら当日の7時を返す' do
      (0..6).each do |h|
        time = Time.current.change(hour: h)
        Time.stub(:current){time}

        t = Mailer.next_appropriate_time
        t.should be_today
        t.hour.should == 7
        t.min.should == 0
      end
    end

    it '現在メール送信可能時間内であれば現在時刻を返す' do
      (7...21).each do |h|
        time = Time.current.change(hour: h)
        Time.stub(:current){time}

        t = Mailer.next_appropriate_time
        t.should == time
      end
    end

    it '現在メール送信可能開始時刻を過ぎていれば翌日の8時を返す' do
      (22 .. 23).each do |h|
        time = Time.current.change(hour: h)
        Time.stub(:current){time}

        t = Mailer.next_appropriate_time
        t.to_date.should == Date.tomorrow
        t.hour.should == 7
        t.min.should == 0
      end
    end
  end
end
