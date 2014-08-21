# encoding:utf-8
require 'spec_helper'

describe BasicLessonWeekdaySchedule do
  describe "validity" do
    it "適切なデータが与えられれば妥当" do
      t1 = Time.zone.now
      BasicLessonWeekdaySchedule.new(wday:0, start_time:t1, units:1).should be_valid
    end
  end

  describe "作成" do
    it "曜日、時間、単位数で作成できる" do
      now = Time.zone.now
      expect {
        BasicLessonWeekdaySchedule.create!(wday:now.wday, start_time:now, units:1)
      }.to change(BasicLessonWeekdaySchedule, :count).by(1)
    end

    it "曜日はwdayで指定した曜日になる" do
      now = Time.zone.now
      wday = (now.wday + 1) % 7
      schedule = BasicLessonWeekdaySchedule.new(wday:wday, start_time:now, units:1)
      schedule.wday.should == wday
      schedule.save!
      BasicLessonWeekdaySchedule.find(schedule.id).wday.should == wday
    end
  end

  describe "end_time" do
    it "終了時刻は自動的に計算される" do
      t1 = Time.zone.now
      schedule = BasicLessonWeekdaySchedule.create(wday:0, start_time:t1, units:1)
      schedule.end_time.should be_present
    end

    it "１単位の場合45分後" do
      t1 = Time.zone.now
      schedule = BasicLessonWeekdaySchedule.create(wday:0, start_time:t1, units:1)
      (schedule.end_time - schedule.start_time).should == (45 * 60)
    end

    it "２単位の場合95分後" do
      t1 = Time.zone.now
      schedule = BasicLessonWeekdaySchedule.create(wday:0, start_time:t1, units:2)
      (schedule.end_time - schedule.start_time).should == (95 * 60)
    end
  end

  describe "wday" do
    around(:each) do |test|
      zone = Time.zone
      test.call
      Time.zone = zone
    end

    it "タイムゾーンに応じて曜日も変わる" do
      Time.zone = "Tokyo"
      t1 = Time.new(2012, 11, 7, 0, 0, 0)
      schedule = BasicLessonWeekdaySchedule.create!(wday:t1.wday, start_time:t1, units:1)
      Time.zone = "UTC"
      schedule2 = BasicLessonWeekdaySchedule.find(schedule.id)
      t2 = schedule2.start_time
      t2.time_zone.to_s.should match("UTC")
      t2.wday.should == ((t1.wday + 6) % 7)
      t2.hour.should == (t1.hour + (24 - 9)) % 24
    end
  end
end
