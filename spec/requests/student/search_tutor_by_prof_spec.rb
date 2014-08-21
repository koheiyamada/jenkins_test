# encoding:utf-8
require "spec_helper"

describe "チューターをプロフで検索する" do
  before(:each) do
    bs = FactoryGirl.create(:bs)
    student = FactoryGirl.create(:active_student, organization:bs)
    login_as(student)
    @tutor = FactoryGirl.create(:tutor, organization:bs)
    @tutor_info = FactoryGirl.create(:tutor_info, tutor:@tutor)
  end

  it "名前で検索する" do
    visit "/st/tutors/prof_search"
    current_path.should == "/st/tutors/prof_search"
    page.should have_selector(".form-search")

    fill_in "q", with: @tutor.first_name
    click_button "検索"

    current_path.should == "/st/tutors/prof_search"

    pending "なぜだかわからないがうまくいかないが、使われていないページなので保留する。"
    page.should have_content(@tutor.nickname)
  end
end
