# encoding:utf-8
require "spec_helper"

describe "Lesson abortion" do
  let(:student) {FactoryGirl.create(:student)}
  before(:each) do
    sign_in_as student
  end

  context "開始されたレッスンがある場合" do
    before(:each) do
      tutor = FactoryGirl.create(:tutor)
      subject = FactoryGirl.create(:subject)
      t = 1.hour.from_now

      tutor.weekday_schedules.create!(wday:t.wday, start_time:t.beginning_of_day, end_time:t.end_of_day)
      tutor.update_available_times

      optional_lesson = {
        tutor_id:tutor.id, subject_id:subject.id, start_time:t
      }
      @lesson = OptionalLesson.new(optional_lesson)
      @lesson.students << student
      @lesson.save!
    end

    #it "レッスンを中止する" do
    #  get "/st/lessons"
    #  response.should render_template(:index)
    #
    #  post "/st/lessons/#{@lesson.id}/abort"
    #  response.should redirect_to("/st/lessons/#{@lesson.id}")
    #  follow_redirect!
    #
    #  response.should render_template(:show)
    #end

    it "レッスンを中止されたチューターのCSポイントが３減る。"

  end

  
end
