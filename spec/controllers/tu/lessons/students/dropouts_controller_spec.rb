# coding:utf-8
require 'spec_helper'

describe Tu::Lessons::Students::DropoutsController do
  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}

  before(:each) do
    sign_in tutor
  end

  describe 'POST create' do
    before(:each) do
      @lesson = FactoryGirl.create(:optional_lesson, tutor: tutor, students: [student])
      @lesson.accept.should be_persisted
      @lesson.student_attended student
      @lesson.tutor_attended
      @lesson.should be_started
    end

    it 'LessonDropoutが増える' do
      expect {
        post :create, lesson_id: @lesson.id, student_id: student.id, format: 'json'
      }.to change(LessonDropout, :count).by(1)
    end

    context '途中キャンセル制限時刻を過ぎている' do
      before(:each) do
        t = 1.second.since(@lesson.dropout_closing_time)
        Time.stub(:now){ t }
      end

      it '取止にできない' do
        post :create, lesson_id: @lesson.id, student_id: student.id, format: 'json'
      end
    end

    context '途中キャンセル制限時刻のギリギリ直前の場合' do
      before(:each) do
        t = 1.second.ago @lesson.dropout_closing_time
        Time.stub(:now){ t }
      end

      it '取止にできる' do
        student.drop_out_from_lesson(@lesson).should be_valid
      end
    end

  end
end
