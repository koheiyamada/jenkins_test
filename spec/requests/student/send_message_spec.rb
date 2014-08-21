# encoding:utf-8
require "spec_helper"

describe "生徒がメッセージを送信する" do
  context "生徒としてログイン中" do
    let(:bs) {FactoryGirl.create(:bs)}
    before(:each) do
      @bs_user = FactoryGirl.create(:bs_user, organization:bs)
      @student = FactoryGirl.create(:active_student, organization:bs)
      login_as(@student)
    end

    #it "BSにメッセージを送る" do
    #  visit "/st/my_messages/new"
    #  page.should have_content(@bs_user.full_name)
    #
    #  select @bs_user.full_name, from:"送り先"
    #  fill_in "件名", with: "Test"
    #  fill_in "本文", with: "This is a test"
    #  click_button "送信"
    #
    #  current_path.should == "/st/my_messages"
    #end

    it "BSにメッセージを送る" do
      visit "/st/my_messages/new"

      check "教育コーチ"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      pending 'JavaScriptによるページ遷移のチェック方法がわからない'
      current_path.should == "/st/my_messages"
    end

    it "チューターにメッセージを送る" do
      tutor = FactoryGirl.create(:tutor, anytime_available:true)
      tutor.anytime_available = true

      info = BasicLessonInfo.new
      info.tutor = tutor
      info.students = [@student]
      info.schedules = [BasicLessonWeekdaySchedule.new(wday:1, start_time:Time.now, units:1)]
      info.save!
      info.submit_to_tutor
      info.accept

      @student.reload.lesson_tutors.should have(1).item

      visit "/st/my_messages/new"
      page.should have_content(tutor.nickname)

      select tutor.nickname, from:"recipients_tutor"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      current_path.should == "/st/my_messages"
    end

    #it "本部アカウントにメッセージを送る" do
    #  hq = HqUser.first
    #
    #  visit "/st/my_messages/new"
    #  page.should have_content(hq.full_name)
    #
    #  select hq.full_name, from:"送り先"
    #  fill_in "件名", with: "Test"
    #  fill_in "本文", with: "This is a test"
    #  click_button "送信"
    #
    #  current_path.should == "/st/my_messages"
    #  page.should have_selector(".messages")
    #end

    it "本部アカウントにメッセージを送る" do
      visit "/st/my_messages/new"

      check "本部"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      current_path.should == "/st/my_messages"
      page.should have_selector(".messages")
    end

  end
end
