# encoding:utf-8
require 'spec_helper'

describe OptionalLesson do
  disconnect_sunspot

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}
  let(:student2) {FactoryGirl.create(:student)}
  let(:lesson){OptionalLesson.new_for_form}

  it '確定すると料金も決まる' do
    lesson.save.should be_true
    lesson.students << student
    lesson.reload.student(student).base_lesson_fee_per_unit.should be_nil
    lesson.tutor = tutor
    lesson.save.should be_true
    lesson.start_time = 1.hour.from_now
    lesson.units = 1
    lesson.save.should be_true
    expect {
      lesson.fix.should be_true
    }.to change{lesson.student(student).base_lesson_fee_per_unit}.from(nil).to(tutor.lesson_fee_for_student(student))
  end
end
