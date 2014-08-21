# encoding:utf-8
require "spec_helper"

describe 'Registeriing to use AID' do
  before(:each) do
    visit '/confirmation1'
    click_button '２０歳未満'
    current_path.should == '/confirmation2'
    click_button 'はい'
    current_path.should == '/mail-certification'
  end

  it 'メールアドレスが入力されていなければエラー' do
    click_button '送信'
    current_path.should == '/process_mail-certification'
  end

  it 'フォームが正しく埋められていればOK' do
    # フォームに入力
    fill_in 'email_confirmation_form_email_local', with: 'shiomkawa'
    fill_in 'email_confirmation_form_email_domain', with: 'soba-project.com'
    fill_in 'email_confirmation_form_email_local_confirmation', with: 'shiomkawa'
    fill_in 'email_confirmation_form_email_domain_confirmation', with: 'soba-project.com'
    click_button '送信'

    current_path.should == '/mail_certification_complete'

    form = ParentRegistrationForm.last
    form.should_not be_blank

    visit "/registration/parents/confirm?token=#{form.confirmation_token}"

    visit '/registration/parents/new'
    page.should have_selector('#new_parent')

    fill_in '姓', with: '下川'
    fill_in '名', with: '拓治'
    fill_in 'せい', with: 'しもかわ'
    fill_in 'めい', with: 'たくじ'
    fill_in '電話番号', with: '111-111-1111'
    fill_in 'address_postal_code1', with: '111'
    fill_in 'address_postal_code2', with: '1111'
    fill_in 'address_state', with: '京都府'
    fill_in 'address_line1', with: '京都府京都市'
    choose 'payment_method_type_yuchopayment'
    choose '男性'

    choose 'Google'
    check 'チューターが魅力的だから'

    click_button '確認'

    parent = Parent.last
    current_path.should == "/registration/parents/#{parent.id}"

    Parent.last.payment_method.should be_a(YuchoPayment)
  end

end
