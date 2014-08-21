# encoding:utf-8
require 'spec_helper'

describe BasicLessonInfo do
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:tutor2) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:active_student)}
  let(:student2) {FactoryGirl.create(:active_student)}
  let(:now) {Time.current}
  let(:basic_lesson_info) do
    schedule = BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
    FactoryGirl.create(:basic_lesson_info,
                       tutor:tutor,
                       students:[student],
                       schedules:[schedule])
  end

  def schedule
    BasicLessonWeekdaySchedule.new(wday:now.wday, start_time:now, units:1)
  end

  def schedule2
    BasicLessonWeekdaySchedule.new(wday:(now.wday + 1) % 6, start_time:now, units:1)
  end

  describe '#close' do
    before(:each) do
      basic_lesson_info.accept
    end

    it '状態がclosedになる' do
      expect {
        basic_lesson_info.close
      }.to change{basic_lesson_info.status}.from('active').to('closed')
    end

    it '同じ時間帯に別のレッスンを登録できるようになる' do
      basic_lesson2 = FactoryGirl.build(:basic_lesson_info,
                                        tutor:tutor2,
                                        students:[student],
                                        schedules:[schedule])
      basic_lesson2.should_not be_valid
      basic_lesson_info.close
      basic_lesson2.should be_valid
    end

    it '自動延長できなくなる' do
      basic_lesson_info.close
      basic_lesson_info.turn_on_auto_extension.should be_false
    end

    it '未来の授業はキャンセルされる' do
      basic_lesson_info.supply_lessons
      basic_lesson_info.close
      basic_lesson_info.lessons.all?{|l| l.cancelled?}.should be_true
    end

    it 'on_closedが呼ばれる' do
      BasicLessonInfo.any_instance.should_receive(:on_closed)

      basic_lesson_info.supply_lessons
      basic_lesson_info.close
    end
  end
end
