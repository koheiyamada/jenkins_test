# encoding:utf-8
require "spec_helper"

describe "Apply for being a tutor" do

  it "フォームが埋められていなければエラー" do
    visit "/tutor_app_forms/first"
    click_link "プライバシーポリシーに同意します"

    current_path.should == "/tutor_app_forms/new"

    page.should have_selector("#new_tutor_app_form")

    # フォームに入力
    fill_in "tutor_app_form_first_name", with:"Takuji"
    fill_in "tutor_app_form_last_name", with:"Shimokawa"
    #fill_in "current_address_postal_code", with:"604-0873"
    #fill_in "current_address_state", with:"京都府"
    #fill_in "current_address_line1", with:"京都市中京区"
    #fill_in "hometown_address_postal_code", with:"816-0961"
    #fill_in "hometown_address_state", with:"福岡県"
    #fill_in "hometown_address_line1", with:"大野城市緑ヶ丘"

    click_button "送信"

    current_path.should == "/tutor_app_forms"
  end

  it "フォームが正しく埋められていればOK" do
    visit "/tutor_app_forms/first"
    click_link "プライバシーポリシーに同意します"

    current_path.should == "/tutor_app_forms/new"
    page.should have_selector("#new_tutor_app_form")

    # フォームに入力
    fill_in 'tutor_app_form_first_name', with: 'Takuji'
    fill_in 'tutor_app_form_last_name', with: 'Shimokawa'
    fill_in 'tutor_app_form_first_name_kana', with: 'たくじ'
    fill_in 'tutor_app_form_last_name_kana', with: 'しもかわ'
    fill_in 'tutor_app_form_nickname', with: 'あはは'
    select_date Date.parse('1976/05/27'), from: 'tutor_app_form_birthday'
    fill_in 'tutor_app_form_phone_number', with: '111-1111'
    #fill_in "tutor_app_form_phone_mail", with:"shimokawa@soba-project.com"
    fill_in 'tutor_app_form_pc_mail', with: 'shiomkawa@soba-project.com'
    #fill_in 'tutor_app_form_pc_mail_confirmation', with: 'shiomkawa@soba-project.com'
    fill_in 'tutor_app_form_skype_id', with: 'hogehoge'
    #fill_in "tutor_app_form_nickname", with:"shimo"
    fill_in 'current_address_postal_code1', with: '604'
    fill_in 'current_address_postal_code2', with: '0873'
    fill_in 'current_address_state', with: '京都府'
    fill_in 'current_address_line1', with: '京都市中京区'
    #fill_in "hometown_address_postal_code", with:"816-0961"
    #fill_in "hometown_address_state", with:"福岡県"
    #fill_in "hometown_address_line1", with:"大野城市緑ヶ丘"

    fill_in '大学', with: '京都大学'
    fill_in '学部', with: '工学部'
    fill_in 'tutor_app_form_grade', with: '1'
    #fill_in "入学年", with:1999
    #fill_in "卒業年", with:2003
    fill_in '出身地', with: '福岡'
    fill_in '高校', with: '筑紫丘高校'
    #fill_in "趣味・活動", with:"語学、勉強会、テレビゲーム"
    # select "小学３年", from:"指導できる学年"
    # select "小学４年", from:"指導できる学年"
    # select "小学５年", from:"指導できる学年"
    # select "小学６年", from:"指導できる学年"
    #fill_in "家庭教師経験", with:"なし"
    #fill_in "指導合格実績", with:"なし"
    fill_in '自己アピール', with: 'がんばります！'
    choose '男性'
    # 授業可能時間

    choose 'Google'

    click_button '送信'

    form = TutorAppForm.last
    form.should_not be_blank

    current_path.should == "/tutor_app_forms/#{form.id}"

    #page.should have_selector("form > .actions > input[type='submit']")
    click_link '送信'
    #click_button "送信"

    current_path.should == "/tutor_app_forms/#{form.id}/accepted"
  end

end
