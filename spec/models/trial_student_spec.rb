# coding:utf-8

require 'spec_helper'

describe TrialStudent do
  let(:tutor) {FactoryGirl.create(:tutor)}
  subject {FactoryGirl.create(:trial_student)}

  describe '作成' do
    it 'デフォルトの値がセットされる' do
      student = TrialStudent.create!
      student.last_name.should == '体験レッスン'
      student.first_name.should == '受講者'
      student.phone_number.should == '075-253-5555'
    end
  end

  describe '削除する' do
    context '未開催のレッスンがある' do
      before(:each) do
        @lesson = FactoryGirl.create(:trial_lesson, tutor: tutor, students: [subject], start_time: 2.hours.from_now, units: 1)
      end

      it 'レッスンも削除される' do
        subject.lessons.should have(1).item
        expect {
          subject.destroy
        }.to change(Lesson, :count).by(-1)
      end
    end
  end
end
