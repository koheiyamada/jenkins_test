# encoding:utf-8
require "spec_helper"

describe "生徒が書いたCSシートを閲覧する" do
  context "BSとしてログイン中" do
    let(:bs) {FactoryGirl.create(:bs)}
    before(:each) do
      @bs_user = FactoryGirl.create(:bs_user, organization:bs)
      login_as(@bs_user)
    end

    it "特定の生徒の授業レポートを見る" do
      student = FactoryGirl.create(:student, organization:bs)
      tutor = FactoryGirl.create(:tutor)
      subject = FactoryGirl.create(:subject)
      start_time = 1.hour.from_now

      tutor.weekday_schedules.create!(wday:start_time.wday, start_time:start_time.beginning_of_day, end_time:start_time.end_of_day)
      tutor.update_available_times

      lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:start_time)
      lesson.student_attended(student)
      cs_sheet = FactoryGirl.create(:cs_sheet, author:student, lesson:lesson, score:5)

      visit "/bs/cs_sheets"
      page.should have_selector(".cs_sheets")
      within(:css, ".cs_sheets") do
        page.should have_selector(".cs_sheet")
      end
    end
  end
end
