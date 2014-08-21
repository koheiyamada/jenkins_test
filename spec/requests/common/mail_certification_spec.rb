# encoding:utf-8
require "spec_helper"

describe "feature #646:" do
  before(:each) do
    visit '/confirmation1'
    click_button '２０歳以上'
    expect(current_path).to eq '/confirmation2'
    click_button 'はい'
    expect(current_path).to eq '/mail-certification'
  end

  it "チェックボックスの確認" do
    expect(page).to have_content('利用契約約款に同意します。')
  end

  it "チェックした場合" do
    check('email_confirmation_form_agree_pledge')
    click_button '送信'
    expect(page).to have_no_content('利用契約約款に同意してください。')
  end

  it "チェックしない場合" do
    uncheck('email_confirmation_form_agree_pledge')
    click_button '送信'
    expect(page).to have_content('利用契約約款に同意してください。')
  end
end