# encoding:utf-8
require 'spec_helper'

describe Bs::StudentOptionalLessonsController do
  disconnect_sunspot

  let(:student) {FactoryGirl.create(:student)}
  let(:tutor) {FactoryGirl.create(:tutor)}
  let(:subject) {FactoryGirl.create(:subject)}

  before(:each) do
    t = 1.day.from_now
    @lesson_attr = {
      tutor_id: tutor.id,
      subject_id: subject.id,
      start_time: t
    }
    bs_user = FactoryGirl.create(:bs_user)
    sign_in(bs_user)
  end

  describe "POST :create" do
    it "indexにリダイレクトする" do
      post :create, student_id:student, optional_lesson:@lesson_attr
      response.should redirect_to(bs_student_optional_lessons_path)
    end

    it "BasicLesson.create_for_monthを呼ぶ" do
      lesson = mock_model(OptionalLesson).as_null_object
      OptionalLesson.should_receive(:new).and_return(lesson)
      lesson.should_receive(:save)

      post :create, student_id:student, optional_lesson:@lesson_attr
    end

  end
end
