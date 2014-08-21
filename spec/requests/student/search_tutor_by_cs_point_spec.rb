# encoding:utf-8
require "spec_helper"

describe "チューターをプロフで検索する" do
  before(:each) do
    student = FactoryGirl.create(:active_student)
    login_as(student)
    @tutor_info = FactoryGirl.create(:tutor_info)
    @tutor = @tutor_info.tutor
  end

  it "CSの高い順にチューターを表示する" do
    visit "/st/tutors/cs"
    current_path.should == "/st/tutors/cs"
    page.should have_selector(".tutors")
  end
end
