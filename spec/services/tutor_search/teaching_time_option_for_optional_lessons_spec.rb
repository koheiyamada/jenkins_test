# coding:utf-8

require 'spec_helper'

describe TutorSearch::TeachingTimeOptionForOptionalLesson do
  TeachingTimeOptionForOptionalLesson = TutorSearch::TeachingTimeOptionForOptionalLesson
  let(:tutor){FactoryGirl.create(:tutor)}

  describe 'create' do
    it 'and_orフィールドはorにセットされる' do
      params = {
        dates: [Date.today.to_s]
      }
      option = TeachingTimeOptionForOptionalLesson.new(params)
      option.and_or.should == 'or'
    end

    context '開始時刻のみが与えられている' do
      before(:each) do
        params = {
          dates: [Date.today.to_s, Date.tomorrow.to_s],
          start_time: {hour: 20, minute: 0}
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        @ranges = option.time_ranges
        @ranges.should have(2).items
      end

      it 'fromがセットされている' do
        @ranges.each do |range|
          range.from.hour.should == 20
          range.from.min.should == 0
        end
      end

      it 'toにはnilがセットされている' do
        @ranges.each do |range|
          range.to.should be_nil
        end
      end
    end

    context '終了時刻のみが与えられている' do
      before(:each) do
        params = {
          dates: [Date.today.to_s, Date.tomorrow.to_s],
          end_time: {hour: 20, minute: 0}
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        @ranges = option.time_ranges
        @ranges.should have(2).items
      end

      it 'toがセットされている' do
        @ranges.each do |range|
          range.to.hour.should == 20
          range.to.min.should == 0
        end
      end

      it 'fromにはnilがセットされている' do
        @ranges.each do |range|
          range.from.should be_nil
        end
      end
    end
  end

  describe 'valid?' do
    context '日付がある' do
      it '日付があればtrueを返す' do
        params = {
          dates: [Date.today.to_s]
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        option.should be_valid
      end
    end

    context '日付が与えられていない' do
      it 'falseを返す' do
        params = {}
        option = TeachingTimeOptionForOptionalLesson.new(params)
        option.should_not be_valid
      end
    end
  end

  describe 'tutor_ids' do
    before(:each) do
      @t = Time.current.change(hour: 19, minute: 0)
      tutor.daily_available_times.create!(start_at: @t, end_at: 3.hours.since(@t))
    end

    context '日付指定無しの場合' do
      it 'nilを返す' do
        option = TeachingTimeOptionForOptionalLesson.new({})
        option.should_not be_valid
        option.tutor_ids.should be_nil
      end
    end

    context '日にちのみ指定がある場合' do
      it '指定した日を登録したチューターのIDを返す' do
        params = {
          dates: [Date.today.to_s]
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        option.tutor_ids.should == [tutor.id]
      end
    end

    context '日にちと開始時刻の指定がある場合' do
      it '指定した時間を含む時間帯を登録してあるチューターを返す' do
        params = {
          dates: [Date.today.to_s],
          start_time: {hour: @t.hour, minute: @t.min}
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        option.tutor_ids.should == [tutor.id]
      end

      it '指定した時間を含まない時間帯しか登録していないチューターを返さない' do
        params = {
          dates: [Date.today.to_s],
          start_time: {hour: @t.hour - 1, minute: @t.min}
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        p option.tutor_ids
        option.tutor_ids.should be_empty
      end
    end

    context '日にちと開始時刻、終了時刻の指定がある場合' do
      it '指定した時間帯を含む時間帯を登録してあるチューターを返す' do
        params = {
          dates: [Date.today.to_s],
          start_time: {hour: @t.hour, minute: @t.min},
          end_time: {hour: @t.hour + 1, minute: @t.min},
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        option.tutor_ids.should == [tutor.id]
      end

      it '指定した時間を含まない時間帯しか登録していないチューターを返さない' do
        params = {
          dates: [Date.today.to_s],
          start_time: {hour: @t.hour - 2, minute: @t.min},
          end_time: {hour: @t.hour - 1, minute: @t.min},
        }
        option = TeachingTimeOptionForOptionalLesson.new(params)
        option.tutor_ids.should be_empty
      end
    end
  end
end
