# encoding:utf-8
require "spec_helper"

describe "Apply for being a BS" do

  it "フォームが埋められていなければエラー" do
    visit "/bs_app_forms/first"
    click_link "プライバシーポリシーに同意する"

    current_path.should == "/bs_app_forms/new"

    page.should have_selector("#new_bs_app_form")

    # フォームに入力
    #fill_in "tutor_info_first_name", with:"Takuji"
    #fill_in "tutor_info_last_name", with:"Shimokawa"

    click_button "送信"

    current_path.should == "/bs_app_forms"
  end

  it "フォームが正しく埋められていればOK" do
    visit "/bs_app_forms/first"
    click_link "プライバシーポリシーに同意する"

    current_path.should == "/bs_app_forms/new"
    page.should have_selector("#new_bs_app_form")

    # フォームに入力
    fill_in '姓', with: '山田'
    fill_in '名', with: '太郎'
    fill_in 'せい', with: 'やまだ'
    fill_in 'めい', with: 'たろう'
    fill_in 'エリア名', with: 'ヤマダ学習塾'
    fill_in '電話番号', with: '111-1111'
    fill_in 'メールアドレス', with: 'shimokawa@soba-project.com'
    fill_in 'bs_app_form_email_confirmation', with: 'shimokawa@soba-project.com'
    #fill_in "スカイプID", with:"hogehoge"
    fill_in 'address_postal_code1', with: '111'
    fill_in 'address_postal_code2', with: '1111'
    fill_in 'address_state', with: '京都府'
    fill_in 'address_line1', with: '京都市中京区少将井御旅町'
    fill_in '職業履歴', with: '教師'
    fill_in '高校', with: '上田高校'
    fill_in '出身地', with: '東京'

    select_date Date.new(1976, 5, 27), from:"bs_app_form_representative_birthday"
    choose '男性'
    fill_in 'エントリー目的', with: 'ビジネス'
    fill_in 'bs_app_form_driver_license_number', with: '111111111'

    choose 'Google'

    #page.should have_selector("form > .actions > input[type='submit']")
    page.should have_selector("form > .actions > input[type='image']")
    click_button "送信"

    current_path.should match("/bs_app_forms/\\d+")
  end

end
