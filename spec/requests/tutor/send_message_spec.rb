# encoding:utf-8
require "spec_helper"

describe "メッセージを送信する" do
  context "チューターとしてログイン中" do
    before(:each) do
      @bs = FactoryGirl.create(:bs)
      @tutor = FactoryGirl.create(:tutor, anytime_available:true)
      login_as(@tutor)
    end

    #it "BSにメッセージを送る" do
    #  bs_user = FactoryGirl.create(:bs_user, organization:@bs)
    #
    #  visit "/tu/my_messages/new"
    #
    #  #select bs_user.full_name, from:"送り先"
    #  check "教育コーチ"
    #  fill_in "件名", with: "Test"
    #  fill_in "本文", with: "This is a test"
    #  click_button "送信"
    #
    #  current_path.should == "/tu/my_messages"
    #end

    it "生徒にメッセージを送る" do
      student = FactoryGirl.create(:active_student, organization:@bs)
      @tutor.students << student

      visit "/tu/my_messages/new"
      page.should have_content(student.nickname)

      select student.nickname, from:"recipients_student"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      current_path.should == "/tu/my_messages"
    end

    it "本部アカウントにメッセージを送る" do
      visit "/tu/my_messages/new"

      check "本部"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      current_path.should == "/tu/my_messages"
      page.should have_selector(".messages")
    end
  end
end
