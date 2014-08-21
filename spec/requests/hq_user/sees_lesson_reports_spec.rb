# encoding:utf-8
require "spec_helper"

describe "本部の管理者がレッスンレポートを見る" do

  context "本部管理者としてログインしているとき" do
    let(:student){FactoryGirl.create(:student)}
    let(:tutor){FactoryGirl.create(:tutor)}
    let(:subject){FactoryGirl.create(:subject)}

    before(:each) do
      hq_user = FactoryGirl.create(:hq_user)
      login_as(hq_user)
    end

    it "すべての生徒のレッスンレポートを見る" do
      start_time = 1.hour.from_now
      lesson = create_optional_lesson(subject:subject, tutor:tutor, student:student, time:start_time)
      lesson_report = FactoryGirl.create(:lesson_report, author:tutor, lesson:lesson, student:student, subject:subject)

      visit "/hq"
      current_path.should == "/hq"
      click_link "レッスンレポート"

      visit "/hq/lesson_reports"
      page.should have_selector(".lesson_report")
      page.should have_content(student.full_name)
    end
  end
end
