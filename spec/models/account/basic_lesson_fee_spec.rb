# encoding:utf-8
require 'spec_helper'

describe Account::BasicLessonFee do
  around(:each) do |test|
    # オブザーバが仕訳データを作成しないように無効化する
    Lesson.observers.disable :all
    test.call()
    Lesson.observers.enable :all
  end

  let(:student) {FactoryGirl.create(:active_student)}
  let(:student2) {FactoryGirl.create(:active_student)}
  let(:tutor) {FactoryGirl.create(:tutor)}

  before(:each) do
    subject = FactoryGirl.create(:subject)
    course = FactoryGirl.create(:shared_basic_lesson_info, tutor:tutor, subject:subject, students:[student, student2])
    @t = 1.hour.from_now
    @lesson = FactoryGirl.build(:basic_lesson, course:course, start_time:@t, units:1)
    @lesson.stub(:journalize!)
    @lesson.save!
  end

  describe "作成する" do
    it "owner, year, month, client, (amount_of_payment または amount_of_money_receied)が要る" do
      Account::BasicLessonFee.new(owner:student, year:@lesson.payment_month.year,
                                  month:@lesson.payment_month.month,
                                  client:Headquarter.instance,
                                  amount_of_payment:@lesson.fee(student),
                                  lesson:@lesson
      ).should be_valid
    end
  end
end
