# encoding:utf-8
require "spec_helper"

describe "レッスンレポートを書く" do
  context "チューターとしてログインしている" do
    before(:each) do
      tutor = FactoryGirl.create(:tutor)
      login_as(tutor)

      @student = FactoryGirl.create(:active_student)
      @subject = FactoryGirl.create(:subject)
      t = 1.month.from_now
      tutor.weekday_schedules.create!(wday:t.wday, start_time:t.beginning_of_day, end_time:t.end_of_day)
      tutor.update_available_times
      @lesson = create_optional_lesson(tutor:tutor, student:@student, subject:@subject, time:t)

      Student.any_instance.stub(:subjects){[@subject]}
    end

    context "授業が終わっている場合" do
      it "レッスンページからレッスンレポートページを開いて書く" do
        @lesson.done!

        visit "/tu/lessons/#{@lesson.id}"
        page.should have_selector(".lesson")
        page.should have_selector(".report > a")

        within(:css, ".student [data-id='#{@student.id}']") do
          click_link "レポートを書く"
        end

        current_path.should == "/tu/lessons/#{@lesson.id}/lesson_reports/new"
        URI.parse(current_url).query.should == "student_id=#{@student.id}"

        page.should have_selector("form#new_lesson_report")

        select @subject.name, from: '教科'
        fill_in "レッスン内容", with: "三単現のS"
        choose "概ね良好"
        fill_in "理解", with: "ばっちり"
        fill_in "宿題", with: "書き取り"
        fill_in "生徒さんへ一言", with: "その調子"
        click_button "提出"

        # レッスンページに戻る
        current_path.should == "/tu/lessons/#{@lesson.id}"
      end

      it "授業と無関係な生徒のIDが指定されていればレッスンページにリダイレクトする"
    end

    context "授業が終わっていない場合" do
      it "レポート作成ページを開くことができない"
    end

    context "すでにレポートが書かれている場合" do
      before(:each) do
        @lesson.done!
        visit "/tu/lessons/#{@lesson.id}/lesson_reports/new?student_id=#{@student.id}"
        fill_in "レッスン内容", with: "理解できてます。"
        choose "概ね良好"
        fill_in "理解", with: "ばっちり"
        fill_in "宿題", with: "書き取り"
        fill_in "生徒さんへ一言", with: "その調子"
        click_button "提出"
        LessonReport.count.should  > 0
      end

      it "「レポートを見る」リンクが表示される" do
        visit "/tu/lessons/#{@lesson.id}"

        within(:css, ".student [data-id='#{@student.id}']") do
          page.should have_selector('.report')
          page.should have_selector('.read-report-button')
          find(:css, '.read-report-button').click
        end

        latest_report = LessonReport.last

        current_path.should == "/tu/lessons/#{@lesson.id}/lesson_reports/#{latest_report.id}"
        page.should have_selector(".lesson_report")
      end

      it "新規作成ページを見ることができない。" do
        report = @lesson.report_of(@student)
        # すでにレポートが書かれた生徒のレポート新規作成ページを開こうとすると、
        visit "/tu/lessons/#{@lesson.id}/lesson_reports/new?student_id=#{@student.id}"
        # レッスンページにリダイレクトされる
        current_path.should == "/tu/lessons/#{@lesson.id}"
      end
    end
  end
end
