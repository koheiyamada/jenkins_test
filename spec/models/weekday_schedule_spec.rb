# encoding:utf-8
require 'spec_helper'

describe WeekdaySchedule do
  let(:tutor){FactoryGirl.create(:tutor)}

  it "start_time, end_timeに与える時間の日付がwdayと異なっていても保存時に修正される" do
    # これは仕様じゃなくてRailsのtimeカラムの動作確認
    from = Time.now
    to = 1.hour.since(from)
    wday = (from.wday + 1) % 7

    w = WeekdaySchedule.create!(wday:wday, start_time:from, end_time:to) do |o|
      o.tutor = tutor
    end

    w.start_time.wday.should == wday
  end

  describe '作成' do
    it '既存の時間帯と重なっているとエラー' do
      t1 = Time.current
      t2 = 1.hour.since t1

      ws = tutor.weekday_schedules.create(start_time: t1, end_time: t2)
      ws.should be_persisted

      t3 = 1.minute.ago t2
      t4 = 1.hour.since t3

      ws2 = tutor.weekday_schedules.create(start_time: t3, end_time: t4)
      ws2.should_not be_persisted
      ws2.errors[:time_range].should be_present
    end

    it '時間帯が重なっていなければOK' do
      t1 = Time.current
      t2 = 1.hour.since t1

      ws = tutor.weekday_schedules.create(start_time: t1, end_time: t2)
      ws.should be_persisted

      t3 = t2
      t4 = 1.hour.since t3

      ws2 = tutor.weekday_schedules.create(start_time: t3, end_time: t4)
      ws2.should be_persisted
    end

    context 'start_timeの時間がend_timeよりもあとの場合' do
      before(:each) do
        @start_time = Time.current
        @end_time = 1.minute.ago @start_time
      end

      it 'end_timeは翌日の時刻とみなす' do
        schedule = FactoryGirl.create(:weekday_schedule, tutor: tutor, start_time: @start_time, end_time: @end_time)
        schedule.wday.should == @start_time.wday
        schedule.end_time.should > schedule.start_time
        schedule.end_time.wday.should == (schedule.wday + 1) % 7
        schedule.end_time.hour.should == @end_time.hour
        schedule.end_time.min.should == @end_time.min
      end
    end
  end
end
