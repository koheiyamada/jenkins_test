# encoding:utf-8
require "spec_helper"

describe "Basic lesson reservation" do
  before(:each) do
    bs = FactoryGirl.create(:bs_user)
    #sign_in_as bs
    login_as bs
  end

  # it "1セットのベーシックレッスンを作成する" do
  #   student = FactoryGirl.create(:student)
  #   tutor = FactoryGirl.create(:tutor)
  #   subject = FactoryGirl.create(:subject)

  #   get "/bs/students/#{student.id}/basic_lessons/new"
  #   response.should render_template(:new)

  #   t = 1.month.from_now
  #   wday = 1

  #   post "/bs/students/#{student.id}/basic_lessons", tutor_id:tutor.id, subject_id:subject.id, year_month:t, time_of_day:{hour:t.hour, minute:t.min}, wday:wday
  #   response.should redirect_to("/bs/students/#{student.id}/basic_lessons")
  #   follow_redirect!

  #   response.should render_template(:index)
  # end
  
  it "1セットのベーシックレッスンを作成する" do
    pending "もはや不要か"

    student = FactoryGirl.create(:active_student)
    tutor = FactoryGirl.create(:tutor)
    subject = FactoryGirl.create(:subject)
    start_time = 1.month.from_now

    tutor.weekday_schedules.create!(wday:1, start_time:Date.today.beginning_of_day, end_time:Date.today.end_of_day)
    tutor.update_available_times

    visit "/bs/students/#{student.id}/basic_lessons/new"

    select tutor.full_name, from:"チューター"
    select subject.name, from:"科目"
    select "%02d年 %02d月" % [start_time.year, start_time.month], from:"月"
    select "月", from:"曜日"
    select start_time.hour.to_s, from:"basic_lesson_form[hour]"
    select (start_time.min / 15 * 15).to_s, :from => "basic_lesson_form[minute]"
    select student.min_lesson_units.to_s, from:"単位数"
    click_button "予約する"

    current_path.should == "/bs/students/#{student.id}/basic_lessons"
  end
end
