# coding:utf-8
require 'spec_helper'

describe TutorDailyAvailableTime do
  let(:tutor){FactoryGirl.create(:tutor)}
  let(:min_range){LessonSettings.minimum_time_range}

  describe 'creation' do
    it '時間は場は60分以上' do
      t1 = 1.hour.from_now
      s = tutor.daily_available_times.build(start_at: t1, end_at: (min_range - 1).minutes.since(t1))
      s.should_not be_valid
      s = tutor.daily_available_times.build(start_at: t1, end_at: min_range.minutes.since(t1))
      s.should be_valid
    end

    it '重複した時間は登録できない' do
      t1 = 1.hour.from_now
      t2 = min_range.minutes.since t1
      s1 = FactoryGirl.create(:tutor_daily_available_time, tutor: tutor, start_at: t1, end_at: t2)

      s2 = FactoryGirl.build(:tutor_daily_available_time, tutor: tutor, start_at: t2, end_at: min_range.minutes.since(t2))
      s2.should be_valid
      s2 = FactoryGirl.build(:tutor_daily_available_time, tutor: tutor, start_at: 1.minutes.ago(t2), end_at: min_range.minutes.since(s1.end_at))
      s2.should_not be_valid

      s2 = FactoryGirl.build(:tutor_daily_available_time, tutor: tutor, start_at: min_range.minutes.ago(t1), end_at: t1)
      s2.should be_valid
      s2 = FactoryGirl.build(:tutor_daily_available_time, tutor: tutor, start_at: min_range.minutes.ago(t1), end_at: 1.minutes.since(t1))
      s2.should_not be_valid
    end

    it '他人の時間とは重なってもよい' do
      t1 = 1.hour.from_now
      t2 = min_range.minutes.since t1
      s1 = FactoryGirl.create(:tutor_daily_available_time, tutor: tutor, start_at: t1, end_at: t2)

      tutor2 = FactoryGirl.create(:tutor)
      s2 = FactoryGirl.build(:tutor_daily_available_time, tutor: tutor2, start_at: t1, end_at: t2)
      s2.should be_valid
    end
  end

  describe 'connected?' do
    it '終了時刻が引き数に与えられた別データの開始時刻と同じであればtrue' do
      t1 = 1.hour.from_now
      s1 = tutor.daily_available_times.create(start_at: t1, end_at: min_range.minutes.since(t1))
      s2 = tutor.daily_available_times.create(start_at: s1.end_at, end_at: min_range.minutes.since(s1.end_at))
      s1.connected?(s2).should be_true
    end

    it '1秒でも間が空いていればfalse' do
      t1 = 1.hour.from_now
      s1 = tutor.daily_available_times.create(start_at: t1, end_at: min_range.minutes.since(t1))
      s2 = tutor.daily_available_times.create(start_at: 1.second.since(s1.end_at), end_at: min_range.minutes.since(s1.end_at))
      s1.connected?(s2).should be_false
    end

    it '開始時刻が引き数に与えられた別データの終了時刻と同じであればtrue' do
      t1 = 1.hour.from_now
      s1 = tutor.daily_available_times.create(start_at: t1, end_at: min_range.minutes.since(t1))
      s2 = tutor.daily_available_times.create(start_at: s1.end_at, end_at: min_range.minutes.since(s1.end_at))
      s2.connected?(s1).should be_true
    end
  end
end
