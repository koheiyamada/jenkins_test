# encoding:utf-8
require "spec_helper"

describe "管理者がメッセージを送信する" do
  context "管理者としてログイン中" do
    before(:each) do
      @hq_user = FactoryGirl.create(:hq_user)
      login_as(@hq_user)
    end

    it "チューターにメッセージを送る" do
      tutor = FactoryGirl.create(:tutor)

      visit "/hq/my_messages/new"
      page.should have_content(tutor.full_name)

      select tutor.full_name, from:"recipients_tutor"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      pending 'JavaScriptによるページ遷移のチェック方法がわからない'
      current_path.should == "/hq/my_messages"
    end

    it "生徒にメッセージを送る" do
      student = FactoryGirl.create(:active_student)

      visit "/hq/my_messages/new"
      page.should have_content(student.full_name)

      select student.full_name, from:"recipients_student"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      pending 'JavaScriptによるページ遷移のチェック方法がわからない'
      current_path.should == "/hq/my_messages"
    end

    it "BSにメッセージを送る" do
      bs = FactoryGirl.create(:bs)
      bs_user = FactoryGirl.create(:bs_user, organization:bs)

      visit "/hq/my_messages/new"
      page.should have_content(bs.name)

      select bs.name, from:"recipients_bs"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      current_path.should == "/hq/my_messages"
    end

    it "受講者全員にメッセージを送る" do
      student = FactoryGirl.create(:active_student)

      visit "/hq/my_messages/new"

      check '受講者全員'
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      current_path.should == "/hq/my_messages"
      page.should have_selector(".messages")
    end

    it "BS全員にメッセージを送る" do
      bs = FactoryGirl.create(:bs)
      bs_user = FactoryGirl.create(:bs_user, organization:bs)

      visit "/hq/my_messages/new"

      check '全BS'
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      current_path.should == "/hq/my_messages"
      page.should have_selector(".messages")
    end

  end
end
