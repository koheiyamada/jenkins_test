# coding:utf-8

require 'spec_helper'

describe TutorLessonCancellation do
  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:lesson) {FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])}

  describe 'create' do
    it '理由がないとエラー' do
      r = lesson.build_tutor_lesson_cancellation(reason: nil)
      r.should_not be_valid
      r.errors[:reason].should be_present
    end
  end

  it 'レッスンはキャンセルされる' do
    expect {
      lesson.create_tutor_lesson_cancellation(reason: 'hoge')
    }.to change{Lesson.find(lesson.id).cancelled?}.from(false).to(true)
  end

  it 'レッスンがキャンセルできない状況だとエラー' do
    lesson
    Lesson.any_instance.stub(:valid?){false}
    tutor_lesson_cancellation = lesson.create_tutor_lesson_cancellation(reason: 'hoge')
    tutor_lesson_cancellation.errors.should_not be_empty
  end
end
