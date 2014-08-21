# encoding:utf-8
require 'spec_helper'

describe Bs::StudentBasicLessonsController do
  disconnect_sunspot

  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:subject) {FactoryGirl.create(:subject)}
  let(:course) { FactoryGirl.create(:basic_lesson_info, tutor:tutor, subject:subject, students:[student]) }

  context "ログイン中" do
    before(:each) do
      bs_user = FactoryGirl.create(:bs_user, user_name:"bs1")
      sign_in(bs_user)
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index', student_id:student
        response.should be_success
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        t = 1.month.from_now
        lesson = FactoryGirl.build(:basic_lesson, course:course, start_time:t)
        lesson.save!

        get 'show', student_id:student, id:lesson
        response.should be_success
      end
    end
  end
end
