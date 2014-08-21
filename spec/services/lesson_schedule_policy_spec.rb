# coding:utf-8
require 'spec_helper'

describe LessonSchedulePolicy do
  let(:student) {FactoryGirl.create(:student)}
  let(:lesson) {FactoryGirl.create(:optional_lesson, students: [student])}

  describe '#start_time_change_limit' do
    it '翌月の締め日最終時刻を返す' do
      lsp = LessonSchedulePolicy.new(lesson)
      t1 = lesson.start_time
      limit = lsp.start_time_change_limit
      limit.should == t1.next_month.change(day: SystemSettings.cutoff_date).end_of_day
    end
  end
end