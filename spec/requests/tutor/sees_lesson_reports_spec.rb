# encoding:utf-8
require "spec_helper"

describe "チューターがレッスンレポートを見る" do

  context "チューターとしてログインしているとき" do
    let(:student){FactoryGirl.create(:student_with_credit_card)}
    let(:tutor){FactoryGirl.create(:tutor)}
    let(:subject){FactoryGirl.create(:subject)}

    before(:each) do
      login_as(tutor)
    end

    # it "特定の生徒のレッスンレポートを見る" do
    #   start_time = 1.hour.from_now
    #   lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:start_time)
    #   lesson_report = FactoryGirl.create(:lesson_report, author:tutor, lesson:lesson, student:student)

    #   visit "/tu/students/#{student.id}/lesson_reports"
    #   page.should have_selector(".lesson_report")
    #   page.should have_content(student.full_name)
    # end

    it "すべての生徒のレッスンレポートを見る" do
      start_time = 1.hour.from_now

      tutor.weekday_schedules.create!(wday:start_time.wday, start_time:start_time.beginning_of_day, end_time:start_time.end_of_day)
      tutor.update_available_times

      lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:start_time)
      lesson_report = FactoryGirl.create(:lesson_report, author:tutor, lesson:lesson, student:student, subject:subject)

      visit "/tu"
      current_path.should == "/tu"
      click_link "レッスンレポート"

      visit "/tu/lesson_reports"
      page.should have_selector(".lesson_report")
      page.should have_content(student.nickname)
    end
  end
end
