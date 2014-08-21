# encoding:utf-8
require "spec_helper"

describe "feature #648:" do
  before(:each) do
    visit '/confirmation1'
    click_button '２０歳以上'
    current_path.should == '/confirmation2'
    click_button 'はい'
    current_path.should == '/mail-certification'
  end

  it "メールアドレス（確認）カラムが無い事" do
    expect(page).to have_css('span.required', text: 'メールアドレス（確認）')
  end

  it "localカラムが無い事" do
    expect(page).to have_css('input#email_confirmation_form_email_local_confirmation')
  end

  it "domainカラムが無い事" do
    expect(page).to have_css('input#email_confirmation_form_email_domain_confirmation')
  end
end

describe "feature #693:" do
  it "支払方法所持確認がスキップされている事" do
    #無料体験モード切り替えページに行く
    #切り替えボタンを押す
    visit '/confirmation1'
    click_button '２０歳以上'
    current_path.should == '/mail-certification'
  end
end



