# encoding: utf-8
require 'spec_helper'

describe St::OptionalLessonsController do
  disconnect_sunspot

  context "ログイン中" do
    let(:student) {FactoryGirl.create(:active_student)}
    let(:tutor) {FactoryGirl.create(:tutor)}
    let(:subject) {FactoryGirl.create(:subject)}

    before(:each) do
      sign_in(student)
    end

    describe "GET 'new'" do
      it "ウィザードページにリダイレクトする" do
        get 'new'
        lesson = assigns(:optional_lesson)
        response.should redirect_to(st_optional_lesson_forms_path(lesson))
      end
    end

    describe "POST :create" do
      before(:each) do
        t = 1.day.from_now
        @lesson_attrs = {
          tutor_id: tutor.id,
          subject_id: subject.id,
          start_time: t
        }
        tutor.weekday_schedules.create!(wday:t.wday, start_time:t.beginning_of_day, end_time:t.end_of_day)
        tutor.update_available_times
      end

      it "indexにリダイレクトする" do
        post :create, optional_lesson:@lesson_attrs
        response.should redirect_to(st_optional_lessons_path)
      end

      it "チューターにメールを送信する" do
        TutorMailer.should_receive(:lesson_request_arrived).and_return(double("mail").as_null_object)
        post :create, optional_lesson:@lesson_attrs
      end
    end

  end
end
