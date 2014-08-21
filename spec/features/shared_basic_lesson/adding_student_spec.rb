# coding:utf-8
require 'spec_helper'

describe 'Adding Student' do

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:active_student)}
  let(:student2) {FactoryGirl.create(:active_student)}
  let(:now) {Time.current}

  subject {FactoryGirl.create(:shared_basic_lesson_info,
                              tutor:tutor,
                              students:[student, student2],
                              schedules:[schedule])}

  def schedule
    BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
  end

  def schedule2
    BasicLessonWeekdaySchedule.new(wday:(now.wday + 1) % 6, start_time:now, units:1)
  end

  # Solrと連携させるため、ユニットテストで実行する内容ではないと判断して、
  # ここに書いている。
  describe '#add_student', :search => true do
    context '空きがある場合' do
      around(:each) do |test|
        Delayed::Worker.delay_jobs = false
        test.call
        Delayed::Worker.delay_jobs = true
      end

      subject {FactoryGirl.create(:shared_basic_lesson_info,
                                  tutor:tutor,
                                  students:[student],
                                  schedules:[schedule])}

      it '検索でfull=falseを指定すると引っかからなくなる' do
        subject.submit_to_tutor.should be_true
        Sunspot.commit
        #p BasicLessonInfo.find(subject.id).full?
        #p SharedBasicLessonInfo.search{fulltext ''}.results.count
        tutor.search_basic_lesson_infos('', full: false).should have(1).item
        subject.add_student(student2).should be_valid
        #p BasicLessonInfo.find(subject.id).full?
        #p SharedBasicLessonInfo.search{with(:full, false); fulltext ''}.results.count
        tutor.search_basic_lesson_infos('', full: false).should be_empty
      end
    end
  end
end
