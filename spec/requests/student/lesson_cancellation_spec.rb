# encoding:utf-8
require "spec_helper"

describe "Lesson cancellation" do
  let(:student) {FactoryGirl.create(:active_student)}

  before(:each) do
    sign_in_as student
  end

  context "開始していないレッスンがある場合" do
    before(:each) do
      tutor = FactoryGirl.create(:tutor)
      subject = FactoryGirl.create(:subject)
      t = 1.month.from_now
      
      tutor.weekday_schedules.create!(wday:t.wday, start_time:t.beginning_of_day, end_time:t.end_of_day)
      tutor.update_available_times

      optional_lesson = {
        tutor_id:tutor.id, subject_id:subject.id, start_time:t
      }
      @lesson = OptionalLesson.new(optional_lesson)
      @lesson.students << student
      @lesson.save!
    end

    it "レッスンをキャンセルする" do
      get "/st/lessons"
      response.should render_template(:index)

      post "/st/lessons/#{@lesson.id}/cancel"
      response.should redirect_to("/st/lessons/#{@lesson.id}")
      follow_redirect!

      response.should render_template(:show)
    end


  end

  
end
