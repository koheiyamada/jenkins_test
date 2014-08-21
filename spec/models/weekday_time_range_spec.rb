# encoding:utf-8

require "spec_helper"

describe WeekdayTimeRange do
  it "start_time, end_timeから作れる" do
    t1 = Time.now
    t2 = 45.minutes.since(t1)
    w = WeekdayTimeRange.new(start_time: t1, end_time: t2)
    w.wday.should == Time.now.wday
    w.start_time.hour.should == t1.hour
    w.start_time.min.should == t1.min
    w.end_time.hour.should == t2.hour
    w.end_time.min.should == t2.min
    w.duration.should == 45
  end

  it "wday, hour, min, duration　から作れる" do
    t1 = Time.now
    d = 48
    w = WeekdayTimeRange.new(wday: t1.wday, hour: t1.hour, min: t1.min, duration: d)
    w.wday.should == t1.wday
    w.start_time.hour.should == t1.hour
    w.start_time.min.should == t1.min
    w.end_time.hour.should == d.minutes.since(t1).hour
    w.end_time.min.should == d.minutes.since(t1).min
    w.duration.should == d
  end
end