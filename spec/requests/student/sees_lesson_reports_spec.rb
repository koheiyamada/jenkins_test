# encoding:utf-8
require "spec_helper"

describe "チューターが書いたレッスンレポートを閲覧する" do
  context "BSとしてログイン中" do
    before(:each) do
      login_as(student)
    end

    let(:student){FactoryGirl.create(:active_student)}
    let(:tutor){FactoryGirl.create(:tutor)}
    let(:subject){FactoryGirl.create(:subject)}

    it "自分に関する授業レポートを見る" do
      start_time = 1.hour.from_now
      tutor.weekday_schedules.create!(wday:start_time.wday, start_time:start_time.beginning_of_day, end_time:start_time.end_of_day)
      tutor.update_available_times
      
      lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:start_time)
      lesson_report = FactoryGirl.create(:lesson_report, author:tutor, lesson:lesson, student:student, subject:subject)

      visit "/st/lesson_reports"
      page.should have_selector(".lesson_report")
      page.should have_content(student.full_name)
    end
  end
end
