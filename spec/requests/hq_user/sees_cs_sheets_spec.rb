# encoding:utf-8
require "spec_helper"

describe "本部の管理者が、生徒が書いたCSシートを閲覧する" do
  context "本部管理者としてログイン中" do
    before(:each) do
      hq_user = FactoryGirl.create(:hq_user)
      login_as(hq_user)
    end

    it "特定の生徒の授業レポートを見る" do
      student = FactoryGirl.create(:student)
      tutor = FactoryGirl.create(:tutor)
      subject = FactoryGirl.create(:subject)
      start_time = 1.hour.from_now

      tutor.weekday_schedules.create!(wday:start_time.wday, start_time:start_time.beginning_of_day, end_time:start_time.end_of_day)
      tutor.update_available_times

      lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:start_time)
      lesson.student_attended(student)
      cs_sheet = FactoryGirl.create(:cs_sheet, author:student, lesson:lesson, score:5)

      visit "/hq/cs_sheets"
      page.should have_selector(".cs_sheets")
      within(:css, ".cs_sheets") do
        page.should have_selector(".cs_sheet")
      end
    end
  end
end
