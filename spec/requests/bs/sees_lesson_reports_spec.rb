# encoding:utf-8
require "spec_helper"

describe "チューターが書いたレッスンレポートを閲覧する" do
  context "BSとしてログイン中" do
    let(:bs){FactoryGirl.create(:bs)}
    let(:student){FactoryGirl.create(:student, organization:bs)}
    let(:tutor){FactoryGirl.create(:tutor)}
    let(:subject){FactoryGirl.create(:subject)}

    before(:each) do
      @bs_user = FactoryGirl.create(:bs_user, organization:bs)
      login_as(@bs_user)

      @start_time = 1.hour.from_now
      tutor.weekday_schedules.create!(wday:@start_time.wday, start_time:@start_time.beginning_of_day, end_time:@start_time.end_of_day)
      tutor.update_available_times
    end

    it "特定の生徒の授業レポートを見る" do
      lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:@start_time)
      lesson_report = FactoryGirl.create(:lesson_report, author:tutor, lesson:lesson, student:student, subject:subject)

      visit "/bs/students/#{student.id}/lesson_reports"
      page.should have_selector(".lesson_report")
      page.should have_content(student.full_name)
    end

    it "すべての生徒の授業レポートを見る" do
      lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:@start_time)
      lesson_report = FactoryGirl.create(:lesson_report, author:tutor, lesson:lesson, student:student, subject:subject)

      visit "/bs/lesson_reports"
      page.should have_selector(".lesson_report")
      page.should have_content(student.full_name)
    end
  end
end
