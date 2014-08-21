# encoding:utf-8
require "spec_helper"

describe "オプションレッスンを予約する" do
  before(:each) do
    bs = FactoryGirl.create(:bs)
    student = FactoryGirl.create(:active_student, organization:bs)
    login_as(student)
    @subject = FactoryGirl.create(:subject)
    @tutor = FactoryGirl.create(:tutor, organization:bs, subjects:[@subject])
  end

  it "レッスンデータが増える" do
    visit "/st/optional_lessons/new"
    lesson = OptionalLesson.last
    current_path.should == "/st/optional_lessons/#{lesson.id}/forms/tutor"

    find(:css, 'ul.tutors a:first').click
    #click_button "選択"

    #current_path.should == "/st/optional_lessons/#{lesson.id}/forms/subject"
    #
    #click_link @subject.name

    current_path.should == "/st/optional_lessons/#{lesson.id}/forms/schedule"

    # TODO: テストを書く
    pending "ここから先がややこしい"

    start_time = 1.hour.from_now
    @tutor.weekday_schedules.create!(wday:start_time.wday, start_time:start_time.beginning_of_day, end_time:start_time.end_of_day)
    @tutor.update_available_times

    select @tutor.user_name, :from => "optional_lesson_tutor_id"
    select @subject.name, :from => "optional_lesson[subject_id]"
    select start_time.year.to_s, :from => "optional_lesson[start_time(1i)]"
    select start_time.month.to_s, :from => "optional_lesson[start_time(2i)]"
    select start_time.day.to_s, :from => "optional_lesson[start_time(3i)]"
    select start_time.hour.to_s, :from => "optional_lesson[start_time(4i)]"
    select (start_time.min / 15 * 15).to_s, :from => "optional_lesson[start_time(5i)]"

    click_button "登録する"

    current_path.should == "/st/lessons/requests"
  end

  it "15分以内のリクエストはエラー" do
    # TODO: テストを書く
    pending "カレンダーから選択する方法を決めるまで保留"

    visit "/st/optional_lessons/new"
    page.should have_selector("#new_optional_lesson")

    start_time = 14.minutes.from_now
    @tutor.weekday_schedules.create!(wday:start_time.wday, start_time:start_time.beginning_of_day, end_time:start_time.end_of_day)
    @tutor.update_available_times

    select @tutor.user_name, :from => "optional_lesson[tutor_id]"
    select @subject.name, :from => "optional_lesson[subject_id]"
    select start_time.year.to_s, :from => "optional_lesson[start_time(1i)]"
    select start_time.month.to_s, :from => "optional_lesson[start_time(2i)]"
    select start_time.day.to_s, :from => "optional_lesson[start_time(3i)]"
    select start_time.hour.to_s, :from => "optional_lesson[start_time(4i)]"
    select (start_time.min / 15 * 15).to_s, :from => "optional_lesson[start_time(5i)]"

    click_button "登録する"

    current_path.should == "/st/optional_lessons"
  end

  it "3コマ連続で取得できる" do
    # TODO: テストを書く
    pending "カレンダーから選択する方法を決めるまで保留"
    visit "/st/optional_lessons/new"
    page.should have_selector("#new_optional_lesson")

    start_time = 1.hour.from_now
    @tutor.weekday_schedules.create!(wday:start_time.wday, start_time:start_time.beginning_of_day, end_time:start_time.end_of_day)
    @tutor.update_available_times

    select @tutor.user_name, :from => "optional_lesson_tutor_id"
    select @subject.name, :from => "optional_lesson[subject_id]"
    select start_time.year.to_s, :from => "optional_lesson[start_time(1i)]"
    select start_time.month.to_s, :from => "optional_lesson[start_time(2i)]"
    select start_time.day.to_s, :from => "optional_lesson[start_time(3i)]"
    select start_time.hour.to_s, :from => "optional_lesson[start_time(4i)]"
    select (start_time.min / 15 * 15).to_s, :from => "optional_lesson[start_time(5i)]"
    select "3", from:"単位数"
    click_button "登録する"

    current_path.should == "/st/lessons/requests"

    lesson = OptionalLesson.last
    lesson.end_time.should == (45 * 3 + 5 * 2).minutes.since(lesson.start_time)
  end
end
