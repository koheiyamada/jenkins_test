# coding:utf-8
require 'spec_helper'

describe LessonMoneyMethods do
  let(:tutor) {FactoryGirl.create :tutor}
  let(:student) {FactoryGirl.create :student}
  let(:student2) {FactoryGirl.create :student}
  let(:lesson) {FactoryGirl.create :optional_lesson, tutor: tutor, students: [student]}
  let(:shared_lesson) {FactoryGirl.create :shared_optional_lesson, tutor: tutor, students: [student, student2]}

  describe '#create_lesson_tutor_wage' do
    it 'LessonTutorWageオブジェクトを作る' do
      expect {
        lesson.create_lesson_tutor_wage
      }.to change(LessonTutorWage, :count).by(1)
    end
  end
end