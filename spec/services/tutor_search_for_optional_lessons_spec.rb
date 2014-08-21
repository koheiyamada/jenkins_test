# coding:utf-8

# Solrの検索ができてない

#require 'spec_helper'
#
#describe TutorSearchForOptionalLessons do
#  let(:tutor){FactoryGirl.create(:tutor)}
#
#  describe 'execute' do
#    before(:each) do
#      @t = Time.current.change(hour: 19, min: 0)
#      tutor.daily_available_times.create!(start_at: @t, end_at: 3.hours.since(@t))
#      search = Tutor.search do
#        with :tutor_id, tutor.id
#        fulltext ''
#      end
#      search.total.should == 1
#    end
#
#    context '日付指定無しの場合' do
#      it 'nilを返す' do
#        search = TutorSearchForOptionalLessons.new({})
#        search.execute.should be_empty
#      end
#    end
#
#    context '日にちのみ指定がある場合' do
#      it '指定した日を登録したチューターのIDを返す' do
#        params = {
#          dates: [Date.today.to_s]
#        }
#        search = TutorSearchForOptionalLessons.new(params)
#        search.execute.should == [tutor]
#      end
#    end
#
#    context '日にちと開始時刻の指定がある場合' do
#      it '指定した時間を含む時間帯を登録してあるチューターを返す' do
#        params = {
#          dates: [Date.today.to_s],
#          start_time: {hour: @t.hour, min: @t.min}
#        }
#        search = TutorSearchForOptionalLessons.new(params)
#        search.execute.should == [tutor]
#      end
#
#      it '指定した時間を含まない時間帯しか登録していないチューターを返さない' do
#        params = {
#          dates: [Date.today.to_s],
#          start_time: {hour: @t.hour - 1, min: @t.min}
#        }
#        search = TutorSearchForOptionalLessons.new(params)
#        search.execute.should be_empty
#      end
#    end
#
#    context '日にちと開始時刻、終了時刻の指定がある場合' do
#      it '指定した時間帯を含む時間帯を登録してあるチューターを返す' do
#        params = {
#          dates: [Date.today.to_s],
#          start_time: {hour: @t.hour, min: @t.min},
#          end_time: {hour: @t.hour + 1, min: @t.min},
#        }
#        search = TutorSearchForOptionalLessons.new(params)
#        search.execute.should == [tutor]
#      end
#
#      it '指定した時間を含まない時間帯しか登録していないチューターを返さない' do
#        params = {
#          dates: [Date.today.to_s],
#          start_time: {hour: @t.hour - 2, min: @t.min},
#          end_time: {hour: @t.hour - 1, min: @t.min},
#        }
#        search = TutorSearchForOptionalLessons.new(params)
#        search.execute.should be_empty
#      end
#    end
#  end
#end
