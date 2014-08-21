# encoding:utf-8
require "spec_helper"

describe "保護者との面談を予約する" do
  context "BSとしてログイン中" do
    before(:each) do
      @bs_user = FactoryGirl.create(:bs_user)
      login_as(@bs_user)
      @parent = FactoryGirl.create(:parent)
    end

    it "保護者との面談予定を作成する" do
      visit "/bs/interviews/new"

      start_time = 1.day.from_now

      select @parent.user_name, from: "interview[user1_id]"
      select @bs_user.user_name, from: "interview[user2_id]"
      select start_time.year.to_s, :from => "interview[start_time(1i)]"
      select start_time.month.to_s, :from => "interview[start_time(2i)]"
      select start_time.day.to_s, :from => "interview[start_time(3i)]"
      select start_time.hour.to_s, :from => "interview[start_time(4i)]"
      select (start_time.min / 15 * 15).to_s, :from => "interview[start_time(5i)]"
      click_button "登録する"

      current_path.should == "/bs/interviews"
      page.should have_content(@parent.user_name)
    end
  end
end
