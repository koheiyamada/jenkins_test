# coding:utf-8
require 'spec_helper'

describe LessonStudent do
  let(:tutor) {FactoryGirl.create :tutor}
  let(:student) {FactoryGirl.create :student}
  let(:student2) {FactoryGirl.create :student}
  let(:lesson) {FactoryGirl.create :optional_lesson, tutor: tutor, students: [student]}
  let(:shared_lesson) {FactoryGirl.create :shared_optional_lesson, tutor: tutor, students: [student, student2]}

  before(:each) do
    tutor.become_regular!
    lesson.accept.should be_valid
  end

  subject {lesson.student(student)}

  describe 'create' do
    it '登録時のチューターのレッスン料を記録する' do
      fee = tutor.lesson_fee_for_student(student)
      p "fee = #{fee}"
      hourly_wage = tutor.hourly_wage
      subject.base_lesson_fee_per_unit.should == fee
      price = tutor.price

      price.hourly_wage = hourly_wage * 2
      price.save!

      tutor.lesson_fee_for_student(student).should_not == fee
      subject.reload.base_lesson_fee_per_unit.should == fee
    end
  end

  describe '#charge' do
    context '通常レッスンの場合' do
      it 'LessonChargeオブジェクトが増える' do
        expect {
          subject.charge.should be_persisted
        }.to change(LessonCharge, :count).by(1)
      end

      it '2回呼んでもLessonChargeは1つしか増えない' do
        expect {
          subject.charge.should be_persisted
          subject.charge.should be_persisted
        }.to change(LessonCharge, :count).by(1)
      end

      it '料金はチューターと受講者で決まる金額' do
        charge = subject.charge
        charge.fee.should == subject.lesson_fee
        charge.fee.should == tutor.lesson_fee_for_student(student)
      end
    end

    context '同時レッスンの場合' do
      subject {shared_lesson.student(student)}

      it '同時レッスン割引が含まれる' do
        charge = subject.charge
        charge.fee.should be < tutor.lesson_fee_for_student(student)
        charge.contains_group_lesson_discount?.should be_true
      end

      it '割引額は2割' do
        charge = subject.charge
        charge.fee.should == (tutor.lesson_fee_for_student(student) * 0.80).to_i
      end
    end
  end
end
