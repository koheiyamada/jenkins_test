# coding:utf-8

require 'spec_helper'

describe LessonRequestRejection do
  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:lesson) {FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])}

  describe 'create' do
    it '理由がないとエラー' do
      r = lesson.build_lesson_request_rejection(reason: nil)
      r.should_not be_valid
      r.errors[:reason].should be_present
    end

    context 'レッスンが申込中状態の場合' do
      before(:each) do
        lesson.should be_under_request
      end

      it 'レッスンの状態が不成立となる' do
        expect {
          lesson.create_lesson_request_rejection(reason: 'Busy')
        }.to change{lesson.reload.status}.from('new').to('rejected')
      end
    end
  end
end
