# encoding:utf-8
require "spec_helper"

describe "チューターの申込リストを見る" do
  let(:hq_user) {FactoryGirl.create(:hq_user)}
  before(:each) do
    sign_in_as hq_user
  end

  it "申込リストを表示する" do
    get "/hq/tutor_app_forms"
    response.should be_success
    # current_path.should == "/hq/tutor_app_forms"
    # page.should have_selector(".tutor_app_forms")
  end
end
