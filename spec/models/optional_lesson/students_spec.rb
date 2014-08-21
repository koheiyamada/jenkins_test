# encoding:utf-8
require 'spec_helper'

describe OptionalLesson do
  disconnect_sunspot

  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:student) {FactoryGirl.create(:student)}
  let(:student2) {FactoryGirl.create(:student)}

  describe '同じ受講者を繰り返し登録する' do
    it '中間テーブルのレコード数は１のまま' do
      lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      LessonStudent.where(lesson_id: lesson.id).should have(1).item
      expect {
        lesson.students << student
      }.to raise_error
    end

    it '中間テーブルのレコード数は１のまま' do
      lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      LessonStudent.where(lesson_id: lesson.id).should have(1).item
      lesson.add_student student
      LessonStudent.where(lesson_id: lesson.id).should have(1).item
      lesson.add_student student
      LessonStudent.where(lesson_id: lesson.id).should have(1).item
    end
  end
end
