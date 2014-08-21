# coding:utf-8
require 'spec_helper'

describe UserMonthlyStat do
  it "適切なパラメータが与えられていればOK" do
    FactoryGirl.build(:user_monthly_stat).should be_valid
  end

  it "年が必要" do
    FactoryGirl.build(:user_monthly_stat, year:nil).should be_invalid
  end

  it "月が必要" do
    FactoryGirl.build(:user_monthly_stat, month:nil).should be_invalid
  end

  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}

  describe '#update_usage' do
    before(:each) do
      Student.any_instance.stub(:can_pay_lesson_extension_fee?){true}
    end

    it 'レッスンとを予約するとその分が加算される' do
      lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      lesson.accept.should be_valid
      lesson.student_attended(student)
      lesson.tutor_attended
      lesson.create_extension_request(student).should be_valid
      lesson.extend!.should be_valid

      usage = student.monthly_stats_for(lesson.settlement_year, lesson.settlement_month)
      expect {
        usage.update_usage
      }.to change{UserMonthlyStat.find(usage.id).lesson_extension_charge}.by(lesson.extension_fee(student))
    end

    it '登録の最中のレッスンはカウントしない' do
      lesson = FactoryGirl.create(:optional_lesson, tutor: nil, status: 'build')
      lesson.students << student
      Lesson.find(lesson.id).students.should have(1).item
      lesson.tutor = tutor
      lesson.save!
      lesson.should_not be_fixed
      lesson.lesson_students.first.base_lesson_fee_per_unit.should be_nil

      usage = student.monthly_stats_for(lesson.settlement_year, lesson.settlement_month)
      expect {
        usage.update_usage
      }.not_to change{UserMonthlyStat.find(usage.id).lesson_charge}
    end
  end
end
