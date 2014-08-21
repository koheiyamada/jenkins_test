# encoding:utf-8
require "spec_helper"

describe "BSがメッセージを送信する" do
  context "BSとしてログイン中" do
    before(:each) do
      @bs = FactoryGirl.create(:bs)
      @bs_user = FactoryGirl.create(:bs_user, organization:@bs)
      login_as(@bs_user)
    end

    #it "チューターにメッセージを送る" do
    #  tutor = FactoryGirl.create(:tutor)
    #
    #  visit '/bs/my_messages/new'
    #  page.should have_content(tutor.full_name)
    #
    #  select tutor.full_name, from:'recipients_tutor'
    #  fill_in '件名', with: 'Test'
    #  fill_in '本文', with: 'This is a test'
    #  click_button "送信"
    #
    #  current_path.should == '/bs/my_messages'
    #end

    it "生徒にメッセージを送る" do
      student = FactoryGirl.create(:active_student, organization:@bs)

      visit "/bs/my_messages/new"
      page.should have_content(student.full_name)

      select student.full_name, from:"recipients_student"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      pending 'JavaScriptによるページ遷移のチェック方法がわからない'
      current_path.should == "/bs/my_messages"
    end

    it "本部アカウントにメッセージを送る" do
      visit "/bs/my_messages/new"

      check "本部"
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      pending 'JavaScriptによるページ遷移のチェック方法がわからない'
      current_path.should == "/bs/my_messages"
      page.should have_selector(".messages")
    end

    it "受講者全員にメッセージを送る" do
      student = FactoryGirl.create(:active_student, organization:@bs)

      visit "/bs/my_messages/new"

      check '受講者全員'
      fill_in "件名", with: "Test"
      fill_in "本文", with: "This is a test"
      click_button "送信"

      pending 'JavaScriptによるページ遷移のチェック方法がわからない'
      current_path.should == "/bs/my_messages"
      page.should have_selector(".messages")
    end

  end
end
