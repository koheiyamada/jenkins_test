# encoding:utf-8
require 'spec_helper'

describe Account::BasicLessonTutorFee do
  around(:each) do |test|
    # オブザーバが仕訳データを作成しないように無効化する
    Lesson.observers.disable :all
    test.call()
    Lesson.observers.enable :all
  end

  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:bs) {FactoryGirl.create(:bs)}

  before(:each) do
    @subject = FactoryGirl.create(:subject)
    course = FactoryGirl.create(:basic_lesson_info, tutor:tutor, subject:@subject, students:[student])
    @t = 1.hour.from_now
    @lesson = FactoryGirl.create(:basic_lesson, course:course, start_time:@t, units:1)
    @lesson.student_attended student
    @lesson.tutor_attended
  end

  describe '作成する' do
    context 'CSシートが揃っている' do
      before(:each) do
        @lesson.class.any_instance.stub(:cs_sheets_collected?){true}
      end

      it '作成できる' do
        entry = FactoryGirl.build(:account_basic_lesson_tutor_fee, owner: tutor,
                                  year: @lesson.payment_month.year, month: @lesson.payment_month.month,
                                  amount_of_money_received: 100, lesson: @lesson)
        entry.save
        entry.should be_valid
      end

      it '支払はレッスンが開催された月と同じ' do
        entry = FactoryGirl.create(:account_basic_lesson_tutor_fee,
          owner: tutor, amount_of_money_received: 100, lesson: @lesson)
        m = DateUtils.aid_month_of_day(@lesson.date)
        entry.year.should == m.year
        entry.month.should == m.month
      end
    end

    context 'CSシートが揃っていない' do
      before(:each) do
        @lesson.class.any_instance.stub(:cs_sheets_collected?){false}
      end

      it 'それでも作成される' do
        entry = FactoryGirl.build(:account_basic_lesson_tutor_fee, owner: tutor,
                                  year: @lesson.payment_month.year, month: @lesson.payment_month.month,
                                  amount_of_money_received: 100, lesson: @lesson)
        entry.save.should be_true
      end
    end
  end
end
