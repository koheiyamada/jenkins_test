# encoding:utf-8
require "spec_helper"

describe "Optional lesson reservation" do
  before(:each) do
    bs = FactoryGirl.create(:bs_user)
    login_as bs
  end

  it "オプションレッスンを１つ作成する" do
    student = FactoryGirl.create(:student)
    tutor = FactoryGirl.create(:tutor)
    subject = FactoryGirl.create(:subject)
    t = 1.month.from_now
    tutor.weekday_schedules.create!(wday:t.wday, start_time:t.beginning_of_day, end_time:t.end_of_day)
    tutor.update_available_times

    visit "/bs/students/#{student.id}/optional_lessons/new"

    start_time = Time.zone.local(t.year, t.month, t.day, t.hour, t.min/15*15)

    select subject.name, from:"optional_lesson[subject_id]"
    select tutor.full_name, from:"optional_lesson[tutor_id]"
    select_datetime start_time, from:"optional_lesson_start_time"
    select student.min_lesson_units.to_s, from:"optional_lesson[units]"
    click_button "登録する"

    current_path.should == "/bs/students/#{student.id}/optional_lessons"
  end
  
end
